//
//  BMFOnlyOnceReloadStrategy.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/12/14.
//
//

#import "BMFOnlyOnceOKReloadStrategy.h"

@interface BMFOnlyOnceOKReloadStrategy()

@property (nonatomic, assign) BOOL loaded;

@end

@implementation BMFOnlyOnceOKReloadStrategy

- (void) handleEvent:(BMFReloadStrategyEvent)event {
	[super handleEvent:event];
	
	[self reload];
	
	if (event!=BMFReloadStrategyEventViewDisappear) [self startTimer];
}

- (void) reload {
	if (self.loaded) return;
	[super reload];
}

- (void) loaded:(BOOL)success {
	[super loaded:success];

	if (success) self.loaded = YES;
}

@end
