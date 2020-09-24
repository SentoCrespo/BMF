//
//  BMFThrottleAspect.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 03/07/14.
//
//

#import "BMFThrottleAspect.h"

@interface BMFThrottleAspect()

@property (nonatomic, strong) NSDate *lastRunDate;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BMFThrottleAspect

- (instancetype) initWithInterval:(NSTimeInterval)interval actionBlock:(BMFActionBlock) actionBlock identifier:(NSString *) identifier {
	BMFAssertReturnNil(interval>0);
	BMFAssertReturnNil(actionBlock);
	BMFAssertReturnNil(identifier.length>0);
	
	self = [super init];
    if (self) {
		_minimumTimeInterval = interval;
        _actionBlock = [actionBlock copy];
		_identifier = [identifier copy];
    }
    return self;
}

- (void) dealloc {
	[self stop];
}

#pragma mark Accessors

- (void) setMinimumTimeInterval:(NSTimeInterval)minimumTimeInterval {
	BMFAssertReturn(minimumTimeInterval>0);
	
	if (minimumTimeInterval==_minimumTimeInterval) return;
	
	_minimumTimeInterval = minimumTimeInterval;
	[self start];
}

- (void) setActionBlock:(BMFActionBlock)actionBlock {
	BMFAssertReturn(actionBlock);
	
	_actionBlock = [actionBlock copy];
}

- (void) setIdentifier:(NSString *)identifier {
	BMFAssertReturn(identifier.length>0);
	
	_identifier = [identifier copy];
}

- (void) setTolerance:(NSTimeInterval)tolerance {
	if (tolerance==_tolerance) return;
	
	_tolerance = tolerance;
	[self start];
}

- (void) setLastRunDate:(NSDate *)lastRunDate {
	[[NSUserDefaults standardUserDefaults] setObject:lastRunDate forKey:self.identifier];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *) lastRunDate {
	return [[NSUserDefaults standardUserDefaults] objectForKey:self.identifier];
}

- (void) start {
	[self stop];
	
	NSDate *nextFireDate = [NSDate date];
	DDLogInfo(@"inside start date: %@",nextFireDate);
	
	NSDate *date = self.lastRunDate;
	if (date) {
		nextFireDate = [date dateByAddingTimeInterval:self.minimumTimeInterval];
	}
	else {
		nextFireDate = [nextFireDate dateByAddingTimeInterval:self.minimumTimeInterval];
	}
	
	self.timer = [NSTimer timerWithTimeInterval:self.minimumTimeInterval+self.tolerance target:self selector:@selector(p_run:) userInfo:nil repeats:YES];
	self.timer.fireDate = nextFireDate;
	
	DDLogInfo(@"fire date: %@",nextFireDate);
	
	self.timer.tolerance = self.tolerance;
	[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void) stop {
	[self.timer invalidate];
	self.timer = nil;
}
				  
- (void) p_run:(NSTimer *) timer {
	DDLogInfo(@"actual fire date: %@",[NSDate date]);
	self.actionBlock(self);
	self.lastRunDate = [NSDate date];
}

- (void) clear {
	self.lastRunDate = nil;
}

@end
