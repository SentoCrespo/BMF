//
//  BMFFileUpdater.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 3/10/14.
//
//

#import "BMFFileUpdater.h"

#import "BMF.h"

@implementation BMFFileUpdater

- (instancetype) initWithLocalFileUrl:(NSURL *) localFileUrl {
	BMFAssertReturnNil(localFileUrl);
	
	self = [super init];
	if (self) {
		_localFileUrl = [localFileUrl copy];
	}
	return self;
}

- (void) setLocalFileUrl:(NSURL *)localFileUrl {
	BMFAssertReturn(localFileUrl);
	
	_localFileUrl = [localFileUrl copy];
}

/// Creates the local file from the resource or from the remote url (if no resource), then loads the data and returns it
- (void) load: (BMFCompletionBlock) completionBlock {
	BMFAssertReturn(completionBlock);
	
	NSError *error = nil;
	if ([self shouldOverrideLocalFile]) {
		if (![BMFUtils copyFileAtURL:self.resourceFileUrl toUrl:self.localFileUrl]) {
			completionBlock(nil,error);
			return;
		}
	}

	NSData *localData = [[NSData alloc] initWithContentsOfURL:self.localFileUrl options:0 error:&error];
	if (localData && self.validator) {
		BMFAssertReturn([self.validator validate:localData]);
	}
	
	completionBlock(localData,error);
}

- (BOOL) shouldOverrideLocalFile {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:self.localFileUrl.path]) return YES;
	if (!self.resourceFileUrl) return NO;
	
	NSDictionary *localFileAttributes = [fileManager attributesOfItemAtPath:self.localFileUrl.path error:nil];
	if (!localFileAttributes) return NO;
	
	NSDictionary *resourceFileAttributes = [fileManager attributesOfItemAtPath:self.resourceFileUrl.path error:nil];
	if (!resourceFileAttributes) return NO;
	
	if ([[resourceFileAttributes fileModificationDate] compare:[localFileAttributes fileModificationDate]]==NSOrderedAscending) {
		return YES;
	}
	
	return NO;
}

/// Updates the local file with the remote. Returns the data inside the file
- (void) update:(BMFCompletionBlock) completionBlock {
	BMFAssertReturn(self.remoteUrl);
	BMFAssertReturn(completionBlock);
	
	id<BMFTaskProtocol> loadTask = [[BMFBase sharedInstance].factory dataLoadTask:self.remoteUrl.absoluteString parameters:nil sender:self];
	
	[loadTask run:^(NSData *result, NSError *error) {
		if (!result) {
			completionBlock(result,error);
			return;
		}
		
		if (self.validator && ![self.validator validate:result]) {
			completionBlock(nil,[NSError errorWithDomain:@"FileUpdater" code:BMFErrorData userInfo:@{ NSLocalizedDescriptionKey : BMFLocalized(@"Error: remote data doesn't validate", nil) }]);
			return;
		}
		
		if (![result writeToURL:self.localFileUrl options:NSDataWritingAtomic error:&error]) {
			completionBlock(nil,error);
			return;
		}
		
		self.lastUpdatedDate = [NSDate date];
		completionBlock(result,error);
	}];
	
}

@end
