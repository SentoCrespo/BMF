//
//  BMFSDWebImageLoader.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/06/14.
//
//

#import "BMFSDWebImageLoader.h"

#import "BMF.h"

@implementation BMFSDWebImageLoader

@synthesize progress = _progress;

- (id)init
{
    self = [super init];
    if (self) {
		_progress = [[BMFProgress alloc] init];
		_options = SDWebImageAllowInvalidSSLCertificates;
    }
    return self;
}


- (void) setUrl:(NSURL *)url {
	_url = url;
	if (_url) [self.progress setKey:_url.absoluteString];
}

- (void) cancel {
	[self.progress stop:nil];
}

- (void) load:(BMFCompletionBlock) completionBlock {
	
	BMFAssertReturn(self.url);
	BMFAssertReturn(completionBlock);

	[_progress start:self.url.absoluteString];
	[[SDWebImageManager sharedManager] downloadWithURL:self.url options:self.options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
		[_progress stop:nil];
		self.progress.totalUnitCount = expectedSize;
		self.progress.completedUnitCount = receivedSize;
	} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
		[_progress stop:error];
		completionBlock(image,error);
	}];
}


@end
