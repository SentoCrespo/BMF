//
//  BMFTriggerBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/11/14.
//
//

#import "BMFTriggerBehavior.h"

@implementation BMFTriggerBehavior

- (IBAction)fire:(id)sender {
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
