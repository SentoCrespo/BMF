//
//  BMFReloadStrategy.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/12/14.
//
//

#import "BMFReloadStrategy.h"

#import "BMF.h"

@interface BMFReloadStrategy()

@property (nonatomic) NSTimer *reloadTimer;
@property (nonatomic) BOOL reloading;
@property (nonatomic) NSDate *lastLoadDate;
@property (nonatomic) BOOL loadedOnceOK;

@end

@implementation BMFReloadStrategy

- (instancetype)init {
	self = [super init];
	if (self) {
		[self bmf_commonInit];
	}
	return self;
}

- (instancetype) initWithReloadBlock:(BMFActionBlock) reloadBlock {
	self = [super init];
	if (self) {
		[self bmf_commonInit];
		_reloadBlock = [reloadBlock copy];
	}
	return self;
}

- (void) bmf_commonInit {
	_reloadInterval = -1;
	_minimumReloadInterval = 1;
}

- (void) dealloc {
	[self stopTimer];
}

#pragma mark Accessors

- (void) setReloadInterval:(NSTimeInterval)reloadInterval {
	BMFAssertReturn(reloadInterval==-1 || reloadInterval>=_minimumReloadInterval);
	_reloadInterval = reloadInterval;
}

- (void) setMinimumReloadInterval:(NSTimeInterval)minimumReloadInterval {
	BMFAssertReturn(_reloadInterval==-1 || _reloadInterval>=minimumReloadInterval);
	_minimumReloadInterval = minimumReloadInterval;
}

#pragma mark Timer methods

- (void) startTimer {
	if (self.reloadInterval<=0) return;
	
	[self stopTimer];
	self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:self.reloadInterval target:self selector:@selector(timerUpdate:) userInfo:nil repeats:YES];
}

- (void) stopTimer {
	[self.reloadTimer invalidate];
	self.reloadTimer = nil;
}

- (void) timerUpdate:(NSTimer *) timer {
	[self reload];
}

- (void) reload {
	if (self.reloading) return;
	if (self.loadedOnceOK && self.lastLoadDate && fabs([self.lastLoadDate timeIntervalSinceNow])<=self.minimumReloadInterval) return;
	
	self.reloading = YES;
	self.reloadBlock(self);
}

#pragma mark Protocol methods

- (void) handleEvent:(BMFReloadStrategyEvent)event {
	if (event==BMFReloadStrategyEventViewDisappear) [self stopTimer];
}

- (void) loaded:(BOOL) success {
	self.reloading = NO;
	self.lastLoadDate = [NSDate date];
	if (success) self.loadedOnceOK = YES;
}


@end
