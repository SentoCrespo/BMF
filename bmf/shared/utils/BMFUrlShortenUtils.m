//
//  BMFUrlShortenUtils.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 17/02/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFUrlShortenUtils.h"

#import "BMFUtils.h"
#import "BMFLoaderOperation.h"
#import "BMFAFURLSessionLoader.h"
#import "BMFHTMLUtils.h"
#import "BMF.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACDelegateProxy.h>

static BMFHTMLUtils *htmlUtils = nil;

@implementation BMFUrlResult
@end

@interface BMFUrlShortenUtils() <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, copy) BMFCompletionBlock completionBlock;
@property (nonatomic, strong) NSURL *currentUrl;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSSet *types;
@end

@implementation BMFUrlShortenUtils

+ (void) initialize {
	htmlUtils = [BMFHTMLUtils new];
}

- (void) recover:(NSURL *) url completion:(BMFCompletionBlock) completionBlock followRedirects:(BOOL)followRedirects acceptableContentTypes:(NSSet *) types {
	
	if (!url) {
		if (completionBlock) completionBlock(nil,[NSError errorWithDomain:@"URL" code:BMFErrorLacksRequiredData userInfo: @{ NSLocalizedDescriptionKey : @"Url should not be nil" } ]);
		return;
	}
	
	self.completionBlock = completionBlock;
	self.types = types;
	
	[[BMFUtils webViewUserAgent:url] subscribeNext:^(NSString *userAgent) {
		@autoreleasepool {
			BMFAFURLSessionLoader *loader = [[BMFAFURLSessionLoader alloc] init];
			loader.url = url;
			loader.userAgent = userAgent;
			loader.acceptableContentTypes = types;
			BMFLoaderOperation *loaderOp = [[BMFLoaderOperation alloc] initWithLoader:loader];
			__weak BMFLoaderOperation *wop = loaderOp;
			loaderOp.completionBlock = ^() {
				@autoreleasepool {
					BMFAFURLSessionLoader *sessionLoader = wop.loader;
					
					NSString *htmlString = [[NSString alloc] initWithData:wop.output encoding:NSUTF8StringEncoding];
					NSString *redirectUrl = [htmlUtils findRefresh:htmlString];
					if (redirectUrl) {
						return [self recover:[NSURL URLWithString:redirectUrl] completion:completionBlock followRedirects:followRedirects acceptableContentTypes:types];
					}
					
					BMFUrlResult *result = [BMFUrlResult new];
					result.url = sessionLoader.finalUrl;
					result.data = wop.output;
					completionBlock(result,wop.progress.failedError);
				}
			};
			
			[[BMFBase sharedInstance].networkQueue addOperation:loaderOp];

		}
	} error:^(NSError *error) {
		DDLogError(@"Error getting web view user agent: %@",error);
	}];
	
}

@end
