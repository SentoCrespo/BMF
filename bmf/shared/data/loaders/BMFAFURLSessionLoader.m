//
//  TNAFNetworkingLoader.m
//  DataSources
//
//  Created by José Manuel Sánchez on 22/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFAFURLSessionLoader.h"

#import "BMF.h"

#import "BMFUtils.h"

#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <malloc/malloc.h>

@interface BMFAFURLSessionLoader() <NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>
	@property (nonatomic, strong) NSURL *finalUrl;
	@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
	@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@end

@implementation BMFAFURLSessionLoader

@synthesize progress = _progress;

- (id)init
{
    self = [super init];
    if (self) {
        self.configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
		_progress = [[BMFProgress alloc] init];
		_progress.progressMessage = BMFLocalized(@"Load Url", nil);
		_method = @"GET";
		
		_responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    }
    return self;
}

- (void) cancel {
	[self.dataTask cancel];
	[self.progress stop:[NSError errorWithDomain:@"com.bmf.UserCancel" code:BMFErrorCancelled userInfo:@{ NSLocalizedDescriptionKey : BMFLocalized(@"Cancelled", nil) }]];
}

- (void) setUrl:(NSURL *)url {
	_url = url;
	if (_url) [self.progress setKey:_url.absoluteString];
}

- (BOOL) callBlocksForUrl:(NSURL *)url result:(id)result error:(NSError *)error {
	if (!self.cache) return NO;
	
	NSArray *blocks = [self.cache objectForKey:self.url];
	if (![blocks isKindOfClass:[NSArray class]]) return NO;
	
	for (BMFCompletionBlock block in blocks) {
		block(result,error);
	}
	
	// Blocks should only be called once
	[self.cache removeObjectForKey:self.url];

	return YES;
}

- (void) load:(BMFCompletionBlock) completionBlock {
	
	BMFAssertReturn(self.url);
	BMFAssertReturn(completionBlock);

	self.finalUrl = self.url;
	
	[_progress start:self.url.absoluteString];
	
	_progress.progressMessage = BMFLocalized(@"Loading data", nil);
	
	if (self.cache) {
		id responseObject = [self.cache objectForKey:self.url];
		if (!responseObject) {
			responseObject = [NSMutableArray array];
		}
		
		if ([responseObject isKindOfClass:[NSMutableArray class]]) {
			[responseObject addObject:completionBlock];
			[self.cache setObject:responseObject forKey:self.url];
		}
		else {
			DDLogInfo(@"Loader returning cached data");
			[_progress stop:nil];
			completionBlock(responseObject,nil);
			return;
		}
	}
	
	NSString *paramsDescription = [self.parameters description];
	if (paramsDescription.length>100) paramsDescription = @"Too big to log";
	DDLogDebug(@"Load url: %@ params: %@",self.url.absoluteString,paramsDescription);
	
	if (!self.sessionManager) self.sessionManager = [AFHTTPSessionManager manager];
	
	[self.sessionManager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition (NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential * __autoreleasing *credential) {
		return NSURLSessionAuthChallengePerformDefaultHandling;
	}];
	
	if (self.requestSerializer) self.sessionManager.requestSerializer = self.requestSerializer;
	if (self.responseSerializer) self.sessionManager.responseSerializer = self.responseSerializer;

	if (self.acceptableContentTypes) self.responseSerializer.acceptableContentTypes = self.acceptableContentTypes;
	
	NSError *error = nil;
	NSMutableURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:self.method URLString:self.url.absoluteString parameters:self.parameters error:&error];
	if (error) {
		BMFLogErrorC(BMFLogNetworkContext,@"Error creating request: %@",error);
	}

	if (self.userAgent) {
		[request addValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
	}
		
	if (self.httpBody) {
		NSData *bodyData = [self.httpBody dataUsingEncoding:NSUTF8StringEncoding];
		if (!bodyData) {
			BMFLogErrorC(BMFLogNetworkContext,@"Error, http body set but no data could be encoded: %@",self.httpBody);
		}
		[request setHTTPBody:bodyData];
	}

	if (self.contentType) {
		[request setValue:self.contentType forHTTPHeaderField:@"Content-Type" ];
	}

	/// WARN: This solves problem in some servers, but maybe it fails for others. It needs more testing!!!!
	[request setValue:nil forHTTPHeaderField:@"Accept-Language"];
	
	if (self.otherHeadersDic) {
		for (NSString *headerField in self.otherHeadersDic) {
			[request setValue:self.otherHeadersDic[headerField] forHTTPHeaderField:headerField];
		}
	}
	
	self.dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
		
		NSHTTPURLResponse *httpResponse = [NSHTTPURLResponse BMF_cast:response];
		
		BMFLogDebugC(BMFLogNetworkContext, @"Network response %ld %@ %@ %@",(long)httpResponse.statusCode,[NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode],response.URL,httpResponse.allHeaderFields);
		NSData *data = responseObject;
		NSString *responseBody = @"Body too big to log";
		
		if (data.length<300) responseBody = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

		BMFLogDebugC(BMFLogNetworkContext, @"Network response body %@",responseBody);

		[_progress stop:error];
		
		if (error) {
			BMFLogErrorC(BMFLogNetworkContext,@"Request error: %@",error);
			
			if (![self callBlocksForUrl:self.url result:nil error:error]) {
				completionBlock(nil,error);
			}
		}
		else {
			[self.cache setObject:responseObject forKey:self.url cost:malloc_size((__bridge const void *)(responseObject))];
			
			if (![self callBlocksForUrl:self.url result:responseObject error:nil]) {
				completionBlock(responseObject,nil);
			}
		}
	}];
	
	@weakify(self);
	[self.sessionManager setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
		@strongify(self);
		[self p_updateProgressTotalUnitCount:task];
		[self p_updateProgressCompletedUnitCount:task];

		DDLogInfo(@"send body data: %f",self.progress.fractionCompleted);
	}];
	
	[self.sessionManager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession *session, NSURLSessionDataTask *task, NSURLResponse *response) {
		@strongify(self);
		
		[self p_updateProgressTotalUnitCount:task];
		
		return NSURLSessionResponseAllow;
	}];
	
	[self.sessionManager setDataTaskDidReceiveDataBlock:^(NSURLSession *session, NSURLSessionDataTask *task, NSData *data) {
		@strongify(self);
		
		[self p_updateProgressTotalUnitCount:task];
		[self p_updateProgressCompletedUnitCount:task];
	}];
	
	[self.sessionManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest *(NSURLSession *session, NSURLSessionTask *task, NSURLResponse *response, NSURLRequest *request) {
		@strongify(self);
		self.finalUrl = request.URL;
		return request;
	}];
	
	NSString *body = self.httpBody;
	if (body.length>100) body = @"Too big to log";
	BMFLogDebugC(BMFLogNetworkContext, @"Network request %@ %@ %@ %@",self.method,request.URL,self.parameters,body);
	
	[self.dataTask resume];
}

- (void) p_updateProgressTotalUnitCount:(NSURLSessionTask *) task {
	int64_t expectedToSend = MAX(task.countOfBytesExpectedToSend,0);
	int64_t expectedToReceive = MAX(task.countOfBytesExpectedToReceive,0);
	self.progress.totalUnitCount = MAX(expectedToSend + expectedToReceive,1);
}

- (void) p_updateProgressCompletedUnitCount:(NSURLSessionTask *) task {
	int64_t sent = MAX(task.countOfBytesSent,0);
	int64_t received = MAX(task.countOfBytesReceived,0);
	self.progress.completedUnitCount = sent+received;
	if (self.progress.totalUnitCount<self.progress.completedUnitCount) self.progress.totalUnitCount = self.progress.completedUnitCount;
}

- (NSURL *) finalUrl {
	
	NSMutableString *finalUrlString = [self.url.absoluteString mutableCopy];
	if (self.parameters.allKeys.count>0) [finalUrlString appendString:@"?"];
	
	[self.parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		NSString *escapedKey = [BMFUtils escapeURLString:key];
		NSString *escapedValue = [BMFUtils escapeURLString:obj];
		[finalUrlString appendString:escapedKey];
		[finalUrlString appendString:@"="];
		[finalUrlString appendString:escapedValue];
		[finalUrlString appendString:@"&"];
	}];
	
	return [NSURL URLWithString:finalUrlString];
}

@end
