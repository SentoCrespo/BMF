//
//  BMFSkipFileBackupOperation.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 27/3/15.
//
//

#import "BMFSkipFileBackupOperation.h"

#import "BMFUtils.h"
#import "BMF.h"

@implementation BMFSkipFileBackupOperation

- (void)main {
	self.progress.completedUnitCount = 0;
	
	BMFAssertReturn(self.fileUrl);
	
	NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.fileUrl.path]) {
        error = [NSError errorWithDomain:@"Operation" code:BMFErrorLacksRequiredData userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat: BMFLocalized(@"File not found at %@", nil),self.fileUrl.path] }];
    }
    else {
        if ([BMFUtils markFileSkipBackup:self.fileUrl error:&error]) {
            for (NSOperation *op in self.dependencies) {
                if ([op isKindOfClass:[BMFOperation class]]) {
                    BMFOperation *previous = (BMFOperation *)op;
                    if (previous.output) {
                        self.output = previous.output;
                        break;
                    }
                }
            }
        }
    }
	
	self.progress.failedError = error;
	self.progress.completedUnitCount = 1;
}

@end
