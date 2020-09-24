//
//  BMFChangeEncodingOperation.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/5/15.
//
//

#import "BMFChangeEncodingOperation.h"

#import "BMF.h"

@implementation BMFChangeEncodingOperation

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
	
	NSError *previousError = nil;
	NSString *string = nil;
	NSData *data = nil;
	for (NSOperation *op in self.dependencies) {
		if ([op isKindOfClass:[BMFOperation class]]) {
			BMFOperation *previous = (BMFOperation *)op;
			if (previous.progress.failedError) previousError = previous.progress.failedError;
			if ([previous.output isKindOfClass:[NSData class]]) {
				data = previous.output;
				break;
			}
			else if ([previous.output isKindOfClass:[NSString class]]) {
				string = previous.output;
				break;
			}
		}
	}
	
	if (data) {
		string = [[NSString alloc] initWithData:data encoding:self.initialEncoding];
	}
	
	if (!string) {
		if (!previousError) {
			previousError = [NSError errorWithDomain:@"Encoding" code:BMFErrorLacksRequiredData userInfo:@{ NSLocalizedDescriptionKey : BMFLocalized(@"No string or data received from previous operation", nil) }];
		}
		self.progress.failedError = previousError;
		self.progress.completedUnitCount = 1;
	}
	else {
		self.output = [string dataUsingEncoding:self.finalEncoding allowLossyConversion:YES];
		
		self.progress.completedUnitCount = 1;
	}
}

@end
