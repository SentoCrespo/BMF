//
//  BMFBlockTimerViewControllerBehavior.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFBlockTimerViewControllerBehavior.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "BMFTimerActionAspect.h"

@interface BMFBlockTimerViewControllerBehavior ()

/// Controls when the timer should be started
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) BMFTimerActionAspect *timerAspect;

@end

@implementation BMFBlockTimerViewControllerBehavior

- (instancetype) initWithActionBlock:(BMFActionBlock) block interval:(float) interval {
	BMFAssertReturnNil(block);
	
	self = [super init];
	if (self) {
		_timerAspect = [BMFTimerActionAspect new];
		_actionOnWillAppear = YES;
		_timerAspect.interval = interval;
		_timerAspect.actionBlock = [block copy];

		[super setEnabled:YES];
	}
	return self;
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

- (void) setActionBlock:(BMFActionBlock)actionBlock {
	BMFAssertReturn(actionBlock);
	
	self.timerAspect.actionBlock = actionBlock;
}

- (BMFActionBlock) actionBlock {
	return self.timerAspect.actionBlock;
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
