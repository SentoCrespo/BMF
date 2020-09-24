//
//  BMFParserOperation.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 06/02/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFParserOperation.h"

#import "BMF.h"

@interface BMFParserOperation()

@property (nonatomic, strong, nonnull) id<BMFParserProtocol> parser;

@end

@implementation BMFParserOperation

- (instancetype) initWithParser:(id<BMFParserProtocol>) parser {
	BMFAssertReturnNil(parser);
	
    self = [super init];
    if (self) {
        self.parser = parser;
		if (self.parser.progress.progressMessage.length==0) self.parser.progress.progressMessage = BMFLocalized(@"Parse Data", nil);
    }
    return self;
}

- (id)init {
	[NSException raise:@"Parser required. Use initWithParser instead" format:@""];
    return nil;
}

- (BMFProgress *) progress {
	return self.parser.progress;
}

- (void) performCancel {
	[self.parser cancel];
}

- (void)performStart {
	
	for (NSOperation *op in self.dependencies) {
		if ([op isKindOfClass:[BMFOperation class]]) {
			BMFOperation *previous = (BMFOperation *)op;
			[self.parser parse:previous.output completion:^(id result,NSError *error) {
				self.output = result;
				self.progress.failedError = error;
				if (error) {
					DDLogError(@"Parse failed: %@",error);
				}
				[self finished];
			}];
		}
		else {
			DDLogWarn(@"Previous operation is not a BMFOperation: %@",op);
		}
	}
	
	if (self.dependencies.count==0) DDLogError(@"Parser operation requires dependencies to get the data to parse");
}


@end
