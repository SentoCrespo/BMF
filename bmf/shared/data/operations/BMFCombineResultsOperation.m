//
//  BMFCombineResultsOperation.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/12/14.
//
//

#import "BMFCombineResultsOperation.h"

#import "NSMutableArray+BMF.h"

@implementation BMFCombineResultsOperation

- (void)main {
	self.progress.completedUnitCount = 0;
	NSMutableArray *results = [NSMutableArray array];
	for (NSOperation *op in self.dependencies) {
		if ([op isKindOfClass:[BMFOperation class]]) {
			BMFOperation *previous = (BMFOperation *)op;
			[results BMF_addObjectSafe:previous.output];
		}
	}
	
	self.output = results;
	
	self.progress.completedUnitCount = 1;
}

@end
