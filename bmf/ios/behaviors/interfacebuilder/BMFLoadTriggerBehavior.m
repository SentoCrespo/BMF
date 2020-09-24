//
//  BMFLoadTriggerBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/12/14.
//
//

#import "BMFLoadTriggerBehavior.h"

@implementation BMFLoadTriggerBehavior

- (void) viewDidLoad {
	if (!self.isEnabled) return;
	
	[self performSelector:@selector(p_sendEvent) withObject:self afterDelay:self.delay];
}

- (void) p_sendEvent {
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) dealloc {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
