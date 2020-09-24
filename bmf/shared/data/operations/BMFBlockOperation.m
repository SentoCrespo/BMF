//
//  BMFBlockOperation.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/01/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFBlockOperation.h"

#import "BMF.h"

@implementation BMFBlockOperation

- (instancetype) initWithBlock: (BMFOperationBlock) block taskId:(NSString *)taskId {
	BMFAssertReturnNil(block);
	BMFAssertReturnNil(taskId.length>0);
	
    self = [super init];
    if (self) {
        _block = [block copy];
		_taskId = [taskId copy];
		self.progress = [[BMFProgress alloc] init];
		self.progress.progressMessage = BMFLocalized(@"Custom Operation", nil);
    }
    return self;
}

- (id)init {
	DDLogError(@"Block operation needs a block to work. Use initWithBlock instead");
    return nil;
}

- (void) setBlock:(BMFOperationBlock)block {
	BMFAssertReturn(block);
	_block = [block copy];
}

- (void) setTaskId:(NSString *)taskId {
	BMFAssertReturn(taskId.length>0);
	
	_taskId = [taskId copy];
}

- (void)performStart {
	[self.progress start:self.taskId];
	self.block(self,^(id result, NSError *error) {
		self.output = result;
		if (self.progress.children.count==0) [self.progress stop:error];
		if (!self.cancelled) [self finished];
	});
}

@end
