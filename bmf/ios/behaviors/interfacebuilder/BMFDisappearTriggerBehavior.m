//
//  BMFDisappearTriggerBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/11/14.
//
//

#import "BMFDisappearTriggerBehavior.h"

#import "BMF.h"
#import "BMFViewController.h"

@implementation BMFDisappearTriggerBehavior

- (void) performInit {
	[super performInit];
	self.beforeDisappear = YES;
	self.triggerForward = YES;
	self.triggerBackward = YES;
}

- (void) viewWillDisappear:(BOOL)animated {
	if (!self.isEnabled) return;
	
	if (self.beforeDisappear) [self queueEvent];
}

- (void) viewDidDisappear:(BOOL)animated {
	if (!self.isEnabled) return;
	
	if (!self.beforeDisappear) [self queueEvent];
}

- (void) queueEvent {
	BMFBlock block = ^{
		BMFViewController *vc = [BMFViewController BMF_cast:self.object];
		if (!vc) {
			[self performSelector:@selector(p_sendEvent) withObject:self afterDelay:self.delay];
		}
		else {
			if ( (self.triggerForward && vc.navigationDirection==BMFViewControllerNavigationDirectionForward) ||
				(self.triggerBackward && vc.navigationDirection==BMFViewControllerNavigationDirectionBackward) ) {
				if (self.delay==0) [self p_sendEvent];
				else [self performSelector:@selector(p_sendEvent) withObject:self afterDelay:self.delay];
			}
		}
	};
	
	if (self.onlyOnce) {
		[BMFUtils performOncePerLaunch:block];
	}
	else {
		block();
	}
}

- (void) p_sendEvent {
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) dealloc {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
