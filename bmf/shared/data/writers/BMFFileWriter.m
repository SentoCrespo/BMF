//
//  TNFileWriter.m
//  DataSources
//
//  Created by José Manuel Sánchez on 30/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFFileWriter.h"

#import "BMF.h"

@implementation BMFFileWriter

@synthesize progress = _progress;

- (instancetype) init {
    self = [super init];
    if (self) {
		_options = NSDataWritingAtomic;
		_progress = [[BMFProgress alloc] init];
		_createIntermediateDirectories = YES;
    }
    return self;
}

- (void) cancel {
	[_progress stop:[NSError errorWithDomain:@"com.bmf.UserCancel" code:BMFErrorCancelled userInfo:@{ NSLocalizedDescriptionKey : BMFLocalized(@"Cancelled", nil) }]];
}

- (void) write:(NSData *)data completion:(BMFCompletionBlock) completionBlock {
	BMFAssertReturn(data);
	
	[self.progress start:_fileUrl.absoluteString];
	
	NSError *error = nil;
	if (self.createIntermediateDirectories) {
		if (![[NSFileManager defaultManager] createDirectoryAtPath:[_fileUrl URLByDeletingLastPathComponent].path withIntermediateDirectories:YES attributes:nil error:&error]) {
			[self.progress stop:error];
			if (completionBlock) completionBlock(nil,error);
			return;
		}
	}

	[data writeToURL:_fileUrl options:self.options error:&error];

	[self.progress stop:error];
	
	if (completionBlock) completionBlock(_fileUrl,error);
}

@end
