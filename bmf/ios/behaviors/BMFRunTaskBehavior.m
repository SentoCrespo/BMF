//
//  BMFLoadTaskBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/11/14.
//
//

#import "BMFRunTaskBehavior.h"

#import "BMF.h"

#import <ReactiveCocoa/RACEXTScope.h>

#import "BMFObserverBehavior.h"
#import "BMFDataConnectionCheckerProtocol.h"
#import "BMFDataConnectionStatusBehavior.h"
#import "BMFOnlyOnceOKReloadStrategy.h"

@interface BMFRunTaskBehavior ()

@property (nonatomic, strong) id<BMFTaskProtocol> task;
@property (nonatomic, assign) BOOL finishedOnce; // Yes if the task completes without error at least once
//@property (nonatomic, assign) BOOL loading;

@end

@implementation BMFRunTaskBehavior

- (instancetype) initWithCreateTaskBlock:(BMFCreateTaskBlock) createTaskBlock completionBlock:(BMFCompletionBlock) completionBlock loader:(id<BMFLoaderViewProtocol>)loader {
	BMFAssertReturnNil(createTaskBlock);
	BMFAssertReturnNil(completionBlock);
	
	self = [super init];
	if (self) {
		_createTaskBlock = [createTaskBlock copy];
		_completionBlock = [completionBlock copy];
		_checkResultBlock = [^BOOL(id result,NSError *error) {
			return (result!=nil);
		} copy];
		_loader = loader;
		_reloadStrategy = [[BMFOnlyOnceOKReloadStrategy alloc] initWithReloadBlock:^(id sender) {
			[self performReload];
		}];
	}
	return self;
}

- (void) setObject:(UIViewController<BMFBehaviorsViewControllerProtocol> *)object {
	BMFAssertReturn(!object || [object conformsToProtocol:@protocol(BMFBehaviorsViewControllerProtocol)]);
	
	[super setObject:object];
	
	if (!object) return;
	
	id<BMFBehaviorsViewControllerProtocol> vc = (id)self.object;
	
	BMFObserverBehavior *foregroundBehavior = [[BMFObserverBehavior alloc] initWithName:UIApplicationWillEnterForegroundNotification block:^(id sender) {
		[self.reloadStrategy handleEvent:BMFReloadStrategyEventForeground];
	}];
	[vc addBehavior:foregroundBehavior];
	
	BMFObserverBehavior *observerBehavior = [[BMFObserverBehavior alloc] initWithName:UIApplicationDidBecomeActiveNotification block:^(id sender) {
		[self.reloadStrategy handleEvent:BMFReloadStrategyEventDidBecomeActive];
	}];
	[vc addBehavior:observerBehavior];
	
	BMFDataConnectionStatusBehavior *dataConnectionBehavior = [[BMFDataConnectionStatusBehavior alloc] initWithBlock:^(BMFDataConnectionStatusBehavior *connectionStatusBehavior) {
		if (![connectionStatusBehavior dataConnectionAvailable]) return;
		[self.reloadStrategy handleEvent:BMFReloadStrategyEventDataConnectionStatusChanged];
	}];
	[vc addBehavior:dataConnectionBehavior];
}

- (void) setReloadStrategy:(id<BMFReloadStrategyProtocol>)reloadStrategy {
	BMFAssertReturn(reloadStrategy);
	_reloadStrategy = reloadStrategy;
	@weakify(self);
	_reloadStrategy.reloadBlock = ^(id sender) {
		@strongify(self);
		[self performReload];
	};
}

- (void) setCheckResultBlock:(BMFTaskResultCheckBlock)checkResultBlock {
	BMFAssertReturn(checkResultBlock);
	_checkResultBlock = [checkResultBlock copy];
}

- (void) viewDidLoad {
	[self.reloadStrategy handleEvent:BMFReloadStrategyEventViewLoaded];
}

- (void) viewWillAppear:(BOOL)animated {
	[self.reloadStrategy handleEvent:BMFReloadStrategyEventViewAppear];
}

- (void) viewWillDisappear:(BOOL)animated {
	[self.reloadStrategy handleEvent:BMFReloadStrategyEventViewDisappear];
}

- (void) setCreateTaskBlock:(BMFCreateTaskBlock)createTaskBlock {
	BMFAssertReturn(createTaskBlock);
	
	_createTaskBlock = [createTaskBlock copy];
}

- (void) setCompletionBlock:(BMFCompletionBlock)completionBlock {
	BMFAssertReturn(completionBlock);

	_completionBlock = [completionBlock copy];
}

- (void) setLoader:(id<BMFLoaderViewProtocol>)loader {
	_loader = loader;
}

- (void) reload {
	[self.reloadStrategy reload];
}

- (void) forceReload {
	[self performReload];
}

- (void) performReload {
//	if (self.loading) return;
	
	self.task = self.createTaskBlock();
	if (!self.task) {
		[self.reloadStrategy loaded:NO];
		BMFLogInfo(@"Task is nil, run task behavior will not reload");
		return;
	}
	
//	if (self.loading) return;
//	self.loading = YES;
	
	if (self.task.progress) [self.loader.progress addChild:self.task.progress];
	@weakify(self);
	[self.task run:^(id result, NSError *error) {
		@strongify(self);

//		self.loading = NO;

		self.completionBlock(result,error);
		
		[self.reloadStrategy loaded:self.checkResultBlock(result,error)];
		
		[self.loader.progress removeChild:self.task.progress];

		self.task = nil;
	}];
}

@end
