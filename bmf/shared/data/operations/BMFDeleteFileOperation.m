//
//  BMFDeleteFileOperation.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/3/15.
//
//

#import "BMFDeleteFileOperation.h"

@implementation BMFDeleteFileOperation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.progress.totalUnitCount = 1;
        self.progress.estimatedTime = 1;
    }
    return self;
}

- (void)main {
	self.progress.completedUnitCount = 0;
	
	BMFAssertReturn(self.fileUrl);
	
	NSError *error = nil;
	if ([[NSFileManager defaultManager] removeItemAtURL:self.fileUrl error:&error]) {
		self.output = self.fileUrl;
	}
	
	self.progress.failedError = error;
	self.progress.completedUnitCount = 1;
}

@end
