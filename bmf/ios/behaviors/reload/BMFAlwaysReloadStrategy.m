//
//  BMFAlwaysReloadStrategy.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/12/14.
//
//

#import "BMFAlwaysReloadStrategy.h"

@implementation BMFAlwaysReloadStrategy

- (void) handleEvent:(BMFReloadStrategyEvent)event {
	[super handleEvent:event];
	
	if (event==BMFReloadStrategyEventViewLoaded) return; // We don't need to load here, we load in will appear
	if (event==BMFReloadStrategyEventForeground || event==BMFReloadStrategyEventViewDisappear) return; // We don't reload here because we are already reloading in becomeactive
	
	[self reload];

	[self startTimer];
}

@end
