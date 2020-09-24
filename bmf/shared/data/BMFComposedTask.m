//
//  BMFComposedTask.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 8/4/15.
//
//

#import "BMFComposedTask.h"

#import "BMF.h"

@implementation BMFComposedTask

- (instancetype) initWithTasks:(nonnull NSArray *) tasks {
	self = [super init];
	if (self) {
		_tasks = tasks;
		_mode = BMFComposedTaskNotifyAll;
		_progress = [BMFProgress new];
		_progress.progressMessage = BMFLocalized(@"Composed task", nil);
	}
	return self;
}

- (BOOL) start: (BMFCompletionBlock) completion {
	return [self run:completion];
}

- (BOOL) run: (BMFCompletionBlock) completion {
	dispatch_group_t tasksGroup = dispatch_group_create();
	
	BOOL startResult = YES;
	
	__block BOOL firstResult = YES;
	__block id finalResult = nil;
	__block NSError *finalError = nil;
	
	for (id<BMFTaskProtocol> task in self.tasks) {
		dispatch_group_enter(tasksGroup);
		[self.progress addChild:task.progress];
		BOOL taskResult = [task run:^(id result, NSError *error) {
			dispatch_group_leave(tasksGroup);
			if (self.mode==BMFComposedTaskNotifyAll) {
				completion(result,error);
			}
			else if (self.mode==BMFComposedTaskNotifyOnlyFirst && firstResult) {
				completion(result,error);
				firstResult = NO;
			}
			finalResult = result;
			finalError = error;
		}];
		
		if (!taskResult) {
			[self.progress removeChild:task.progress];
			dispatch_group_leave(tasksGroup);
		}
		
		startResult &= taskResult;
	}
	
	dispatch_group_notify(tasksGroup, dispatch_get_global_queue(0, 0), ^{
		if (self.mode==BMFComposedTaskWaitForAll) {
			completion(finalResult,finalError);
		}
	});
	
	return startResult;
}

- (void) cancel {
	for (id<BMFTaskProtocol> task in self.tasks) {
		[task cancel];
	}
}

- (void) action:(id)input completion:(BMFCompletionBlock)completion {
	[self run:completion];
}

@end
