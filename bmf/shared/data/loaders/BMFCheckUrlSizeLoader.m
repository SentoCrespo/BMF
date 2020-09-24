//
//  BMFCheckUrlSizeLoader.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 27/3/15.
//
//

#import "BMFCheckUrlSizeLoader.h"

#import "BMF.h"

#import <AFNetworking/AFNetworking.h>

@interface BMFCheckUrlSizeLoader()

//@property (nonatomic) AFHTTPRequestOperation *requestOperation;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation BMFCheckUrlSizeLoader

- (id)init {
	self = [super init];
	if (self) {
		_progress = [[BMFProgress alloc] init];
		_progress.progressMessage = BMFLocalized(@"Check Url Download Size", nil);
	}
	return self;
}

- (NSString *) p_progressKey {
	return [NSString stringWithFormat:@"%@_checkSize",_url.absoluteString];
}

- (void) setUrl:(NSURL *)url {
	_url = url;
	if (_url) [self.progress setKey:[self p_progressKey]];
}

- (void) load:(BMFCompletionBlock) completionBlock {
	BMFAssertReturn(self.url);
	BMFAssertReturn(completionBlock);

	[_progress start:[self p_progressKey]];

	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
	[request setHTTPMethod:@"HEAD"];
	
	self.dataTask = [[AFHTTPSessionManager manager] dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
		[self.progress stop:error];
		completionBlock(@(response.expectedContentLength),error);
	}];
	
	[self.dataTask resume];
	
//	self.requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//	@weakify(self);
//	[self.requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//		@strongify(self);
//		[self.progress stop:nil];
//		completionBlock(@([operation.response expectedContentLength]),nil);
//	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//		 @strongify(self);
//		 [self.progress stop:error];
//		 completionBlock(nil,error);
//	 }];
//	
//	[self.requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//		@strongify(self);
//		self.progress.totalUnitCount = MAX(totalBytesExpectedToWrite,0);
//		self.progress.completedUnitCount = MAX(totalBytesWritten,0);
//	}];
	
//	[self.requestOperation resume];
}

- (void) cancel {
	[self.dataTask cancel];
	[_progress stop:[NSError errorWithDomain:@"com.bmf.UserCancel" code:BMFErrorCancelled userInfo:@{ NSLocalizedDescriptionKey : BMFLocalized(@"Cancelled", nil) }]];
}

@end
