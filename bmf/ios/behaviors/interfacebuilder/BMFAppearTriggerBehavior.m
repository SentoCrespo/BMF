//
//  BMFAppearTriggerBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/11/14.
//
//

#import "BMFAppearTriggerBehavior.h"

#import "BMFViewController.h"

#import "BMF.h"

@interface BMFAppearTriggerBehavior()

@property (nonatomic) BOOL triggered;

@end

@implementation BMFAppearTriggerBehavior

- (void) performInit {
	[super performInit];
	self.triggerForward = YES;
	self.triggerBackward = YES;
}

- (void) viewWillAppear:(BOOL)animated {
	if (!self.isEnabled) return;

	if (self.beforeAppear) [self queueEvent];
}

- (void) viewDidAppear:(BOOL)animated {
	if (!self.isEnabled) return;
	
	if (!self.beforeAppear) 	[self queueEvent];
}

- (void) queueEvent {
	BMFBlock block = ^{
		BMFViewController *vc = [BMFViewController BMF_cast:self.object];
		if (!vc) {
			if (self.delay==0) [self p_sendEvent];
			else [self performSelector:@selector(p_sendEvent) withObject:self afterDelay:self.delay];
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
		if (self.triggered) block();
		self.triggered = YES;
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
