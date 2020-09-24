//
//  BMFOnlyOnceReloadStrategy.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/12/14.
//
//

#import "BMFOnlyOnceReloadStrategy.h"

@interface BMFOnlyOnceReloadStrategy()

@property (nonatomic, assign) BOOL loaded;

@end

@implementation BMFOnlyOnceReloadStrategy

- (void) handleEvent:(BMFReloadStrategyEvent)event {
	[super handleEvent:event];
	
	if (!self.loaded) [self reload];
	
	[self startTimer];
}

- (void) loaded:(BOOL)success {
	[super loaded:success];
	
	self.loaded = YES;
}

@end
