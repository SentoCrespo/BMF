//
//  TNWriterOperation.m
//  DataSources
//
//  Created by José Manuel Sánchez on 13/11/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFWriterOperation.h"

@interface BMFWriterOperation()

@property (strong, nonatomic) id<BMFWriterProtocol> writer;

@end

@implementation BMFWriterOperation

- (instancetype) initWithWriter:(id<BMFWriterProtocol>) writer {
	BMFAssertReturnNil(writer);
	
//	if (!writer) {
//		[NSException raise:@"Writer required" format:@""];
//		return nil;
//	}
	
    self = [super init];
    if (self) {
		self.writer = writer;
    }
    return self;
}

- (id)init {
	[NSException raise:@"writer required. Use initWithWriter instead" format:@""];
    return nil;
}

- (BMFProgress *) progress {
	return self.writer.progress;
}

- (void) performCancel {
	[self.writer cancel];
}

- (void)performStart {
	
	NSError *error = nil;
	NSData *data = nil;

	for (NSOperation *op in self.dependencies) {
		if ([op isKindOfClass:[BMFOperation class]]) {
			BMFOperation *previous = (BMFOperation *)op;
			if ([previous.output isKindOfClass:[NSData class]]) {
				data = previous.output;
			}
			if (previous.progress.failedError) error = previous.progress.failedError;
		}
	}
	
	if (data) {
		[self.writer write:data completion:^(id result,NSError *error) {
			self.output = result;
			if (error) {
				DDLogError(@"Write operation failed: %@",error);
			}
			[self finished];
		}];
	}
	else {
		self.output = nil;
		self.progress.failedError = error;
		[self finished];
	}
}

@end
