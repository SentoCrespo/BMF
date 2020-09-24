//
//  BMFManualTriggerBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/3/15.
//
//

#import "BMFManualTriggerBehavior.h"

#import "BMF.h"

@implementation BMFManualTriggerBehavior

- (IBAction) fire:(id)sender {
	if (!self.enabled) return;
	
	if (self.delay==0) [self p_sendEvent];
	else [self performSelector:@selector(p_sendEvent) withObject:self afterDelay:self.delay];
}

- (void) p_sendEvent {
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) dealloc {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
