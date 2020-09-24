//
//  BMFAsyncOperation.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 08/01/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFAsyncOperation.h"

@implementation BMFAsyncOperation {
	BOOL _isExecuting;
	BOOL _isFinished;
}

//@synthesize cancelled = _cancelled;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.progress = [BMFProgress new];
    }
    return self;
}

- (void)start {
	if ([self isCancelled]) 	{
		[self willChangeValueForKey:@"isFinished"];
		_isFinished = YES;
		[self didChangeValueForKey:@"isFinished"];
		return;
	}
 
	// If the operation is not canceled, begin executing the task.
	[self willChangeValueForKey:@"isExecuting"];
	[self main];
//	[NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
	_isExecuting = YES;
	[self didChangeValueForKey:@"isExecuting"];
}

//- (void) start {
//	
//	if ([self isCancelled]) {
//		// Must move the operation to the finished state if it is canceled.
//		[self willChangeValueForKey:@"isFinished"];
//		_isFinished = YES;
//		[self didChangeValueForKey:@"isFinished"];
//		return;
//	}
//	
//	[self willChangeValueForKey:@"isExecuting"];
//	[self willChangeValueForKey:@"isFinished"];
//	_isExecuting = YES;
//	_isFinished = NO;
//	[self didChangeValueForKey:@"isExecuting"];
//	[self didChangeValueForKey:@"isFinished"];
//
//	//if (self.progress.children.count==0) [self.progress start:@"com.bmf.AsyncOperation"];
//	
//	[self performStart];
//}

- (void) cancel {
	[self performCancel];
	
	//if (self.progress.children.count==0) [self.progress stop:nil];
	
	if (self.isExecuting) [self finished];
	
//	[self willChangeValueForKey:@"isCancelled"];
//	_cancelled = YES;
//	[self didChangeValueForKey:@"isCancelled"];

}

- (void)finished {
	[self willChangeValueForKey:@"isFinished"];
	[self willChangeValueForKey:@"isExecuting"];
	_isExecuting = NO;
	_isFinished = YES;
	[self didChangeValueForKey:@"isExecuting"];
	[self didChangeValueForKey:@"isFinished"];
}

- (BOOL) isExecuting {
	return _isExecuting;
}

- (BOOL) isConcurrent {
	return YES;
}

- (BOOL) isFinished {
	return _isFinished;
}

- (void) main {
	@try {
		[self performStart];
	}
	@catch (NSException *exception) {
		DDLogError(@"Exception in operation: %@",exception);
	}
}

- (void) performStart {}
- (void) performCancel {}

- (void) dealloc {
	[self performCancel];
}

@end
