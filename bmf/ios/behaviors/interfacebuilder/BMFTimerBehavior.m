//
//  BMFTimerBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 13/2/15.
//
//

#import "BMFTimerBehavior.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BMFTimerActionAspect.h"

@interface BMFTimerBehavior ()

/// Controls when the timer should be started
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) BMFTimerActionAspect *timerAspect;

@end

@implementation BMFTimerBehavior

- (void) viewDidLoad {
	if (!self.enabled) return;
	
	_timerAspect = [BMFTimerActionAspect new];
	_actionOnWillAppear = YES;
	_timerAspect.interval = self.interval;
	@weakify(self);
	_timerAspect.actionBlock = ^(id sender) {
		@strongify(self);
		if (!self.enabled) return;
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	};
}

- (void) setEnabled:(BOOL)enabled {
	[super setEnabled:enabled];
	[self updateTimerAspect];
}

- (void) setActive:(BOOL)active {
	_active = active;
	[self updateTimerAspect];
}

- (void) updateTimerAspect {
	if (self.enabled && self.active) {
		self.timerAspect.enabled = YES;
	}
	else {
		self.timerAspect.enabled = NO;
	}
}

- (void) viewWillAppear:(BOOL)animated {
	self.active = YES;
	if (self.actionOnWillAppear && self.enabled) {
		self.timerAspect.actionBlock(self.object);
	}
}

- (void) viewWillDisappear:(BOOL)animated {
	self.active = NO;
}

- (void) dealloc {
	self.active = NO;
	self.enabled = NO;
}

- (void) setInterval:(float)interval {
	self.timerAspect.interval = interval;
}

- (float) interval {
	return self.timerAspect.interval;
}

@end
