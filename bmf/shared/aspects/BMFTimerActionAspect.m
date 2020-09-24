//
//  BMFTimerActionAspect.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/07/14.
//
//

#import "BMFTimerActionAspect.h"

#import "BMFTypes.h"

@interface BMFTimerActionAspect()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BMFTimerActionAspect {
	RACDisposable *becomeActiveSubscription;
	RACDisposable *resignActiveSubscription;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _enabled = YES;
		_interval = 5;
		[self enable];
    }
    return self;
}

- (void) dealloc {
	[self disable];
}

- (void) setEnabled:(BOOL)enabled {
	_enabled = enabled;
	
	if (enabled) {
		[self enable];
	}
	else {
		[self disable];
	}
}

- (void) enable {
	becomeActiveSubscription = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFApplicationDidBecomeActiveNotification object:nil] subscribeNext:^(id x) {
		[self startTimer];
	}];
	
	resignActiveSubscription = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFApplicationWillResignActiveNotification object:nil] subscribeNext:^(id x) {
		[self stopTimer];
	}];
	
	[self startTimer];
}

- (void) disable {
	[becomeActiveSubscription dispose], becomeActiveSubscription = nil;
	[resignActiveSubscription dispose], resignActiveSubscription = nil;

	[self stopTimer];
}

- (void) setInterval:(float)interval {
	_interval = interval;
	[self stopTimer];
	[self startTimer];
}

- (void) startTimer {
	if (!self.enabled) return;
	
	if (self.timer) [self stopTimer];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(update:) userInfo:nil repeats:YES];
	[self.timer fire];
}

- (void) stopTimer {
	[self.timer invalidate], self.timer = nil;
}


- (void) update:(id) sender {
	if (self.actionBlock) self.actionBlock(self.object);
}

@end
