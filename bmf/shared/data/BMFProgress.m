//
//  TNProgress.m
//  DataSources
//
//  Created by José Manuel Sánchez on 12/11/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFProgress.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "BMF.h"

#import "BMFAverageTime.h"

@interface BMFProgress()

@property (nonatomic) BOOL started;
@property (nonatomic) BOOL running;
@property (nonatomic) NSHashTable *children;
@property (nonatomic, copy) BMFActionBlock progressChangedBlock;

@end

@implementation BMFProgress {
	dispatch_queue_t serialQueue;
}

@synthesize started = _started;
@synthesize running = _running;
@synthesize estimatedTime = _estimatedTime;
@synthesize totalUnitCount = _totalUnitCount;
@synthesize completedUnitCount = _completedUnitCount;
@synthesize progressMessage = _progressMessage;
@synthesize failedError = _failedError;

- (id)init {
    self = [super init];
    if (self) {
		serialQueue = dispatch_queue_create("BMFProgress queue", DISPATCH_QUEUE_SERIAL);
		
		self.totalUnitCount = 1;
		self.estimatedTime = 1; // 1 second by default
    }
    return self;
}

- (NSHashTable *) children {
	__block NSHashTable *result = nil;
	dispatch_sync(serialQueue, ^{
		if (!_children) _children = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
		result = _children;
	});
	
	return result;
}

- (void) notifyChanged {
	if (self.progressChangedBlock) self.progressChangedBlock(self);
	if (self.changedBlock) self.changedBlock(self);
}

- (void) updateValuesFromChildren {
	__block NSTimeInterval total = 0;
	__block NSTimeInterval completed = 0;
	__block NSTimeInterval estimated = 0;
    __block BOOL someoneStarted = NO;
    __block BOOL someoneNotStartedYet = NO;

	[self willChangeValueForKey:@"progressMessage"];
	[self willChangeValueForKey:@"running"];
	[self willChangeValueForKey:@"fractionCompleted"];
	[self willChangeValueForKey:@"totalUnitCount"];
	[self willChangeValueForKey:@"completedUnitCount"];
	[self willChangeValueForKey:@"estimatedTime"];
	
	dispatch_sync(serialQueue, ^{
		_progressMessage = nil;
		_running = NO;
		
        
		NSHashTable *allChildren = [_children copy];
		for (BMFProgress *child in allChildren) {
			if (child.running) {
				_running = YES;
				
				NSString *childMessage = child.progressMessage;
				if (childMessage.length>0 && !_progressMessage) {
					_progressMessage = childMessage;
				}
			}
            
            if (!child.started) {
                someoneNotStartedYet = YES;
            }
            else {
                someoneStarted = YES;
            }
			
			NSTimeInterval childEstimated = child.estimatedTime;
			CGFloat childTotal = childEstimated*1000;
			
			total += childTotal;
			completed += child.fractionCompleted*childTotal;
			estimated += childEstimated;
		}
		
        // This is used to prevent stopping loaders between operations, when one progress has finished but the next one hasn't started yet.
        if (!_running && someoneNotStartedYet && someoneStarted) _running = YES;
        
		_totalUnitCount = total;
		_completedUnitCount = completed;
		_estimatedTime = estimated;
	});

	[self didChangeValueForKey:@"estimatedTime"];
	[self didChangeValueForKey:@"completedUnitCount"];
	[self didChangeValueForKey:@"totalUnitCount"];
	[self didChangeValueForKey:@"fractionCompleted"];
	[self didChangeValueForKey:@"running"];
	[self didChangeValueForKey:@"progressMessage"];
	
	[self notifyChanged];
}

- (NSTimeInterval) totalUnitCount {
	__block NSTimeInterval result = 0;
	
	dispatch_sync(serialQueue, ^{
		result = _totalUnitCount;
	});
	
	// Don't allow a total unit count less than 1
	return MAX(result,1);
}

- (void) setTotalUnitCount:(NSTimeInterval)totalUnitCount {
	[self willChangeValueForKey:@"totalUnitCount"];
	[self willChangeValueForKey:@"fractionCompleted"];
	dispatch_sync(serialQueue, ^{
		_totalUnitCount = totalUnitCount;
	});
	[self didChangeValueForKey:@"fractionCompleted"];
	[self didChangeValueForKey:@"totalUnitCount"];
	
	if (self.key.length>0) [BMFAverageTime setEffort:totalUnitCount forKey:self.key sender:self];
}

- (CGFloat) fractionCompleted {
	__block CGFloat result = 0;
	dispatch_sync(serialQueue, ^{
		if (_totalUnitCount==0) result = 0;
		else {
			result = _completedUnitCount/(CGFloat)_totalUnitCount;	
		}
	});
	
	// Result should be between 0 and 1
	return MAX(MIN(result,1),0);
}

- (void) setProgressMessage:(NSString *)progressMessage {
	dispatch_sync(serialQueue, ^{
		_progressMessage = [progressMessage copy];
	});
	
	[self notifyChanged];
}

- (NSString *) progressMessage {
	__block NSString *result = nil;
	dispatch_sync(serialQueue, ^{
		result = [_progressMessage copy];
	});

	return result;
}

- (void) clear {
	self.running = NO;
	self.completedUnitCount = 0;
	self.progressMessage = nil;
	self.failedError = nil;
}

- (void) reset {
	dispatch_sync(serialQueue, ^{
		for (BMFProgress *child in _children) {
			child.progressChangedBlock = nil;
		}

		[_children removeAllObjects];
	});

	[self clear];
}

- (void) setKey:(NSString *)key {
	dispatch_sync(serialQueue, ^{
		_key = key;
	});
	
	if (key.length>0) {
		NSTimeInterval estimatedTime = [BMFAverageTime averageTime:key effort:self.totalUnitCount];
		if (estimatedTime!=BMFInvalidDouble)	 self.estimatedTime = estimatedTime;
	}
}

- (BOOL) started {
    __block BOOL result = NO;
    dispatch_sync(serialQueue, ^{
        result = _started;
    });
    return result;
}

- (void) setStarted:(BOOL)started {
    dispatch_sync(serialQueue, ^{
        _started = started;
    });
    
    [self notifyChanged];
}

- (BOOL) running {
	__block BOOL result = NO;
	dispatch_sync(serialQueue, ^{
		result = _running;
	});
	return result;
}

- (void) setRunning:(BOOL)running {
	dispatch_sync(serialQueue, ^{
		_running = running;
	});
    
    if (running) {
        self.started = YES; // This already notifies changes
    }
    else {
        [self notifyChanged];
    }
}

- (NSTimeInterval) estimatedTime {
	__block NSTimeInterval result = 0;
	dispatch_sync(serialQueue, ^{
		result = _estimatedTime;
	});
	
	// Don't allow 0 as estimated time
	return MAX(result,0.000001);
}

- (void) setEstimatedTime:(NSTimeInterval)estimatedTime {
	dispatch_sync(serialQueue, ^{
		_estimatedTime = estimatedTime;
	});

	[self notifyChanged];
}

- (NSTimeInterval) completedUnitCount {
	__block NSTimeInterval result = 0;
	dispatch_sync(serialQueue, ^{
		result = _completedUnitCount;
	});
	
	return result;
}

- (void) setCompletedUnitCount:(NSTimeInterval)completedUnitCount {
	[self willChangeValueForKey:@"completedUnitCount"];
	[self willChangeValueForKey:@"fractionCompleted"];
	dispatch_sync(serialQueue, ^{
		_completedUnitCount = completedUnitCount;
	});
	[self didChangeValueForKey:@"fractionCompleted"];
	[self didChangeValueForKey:@"completedUnitCount"];
	
	[self notifyChanged];
}

- (NSError *) failedError {
	__block NSError *result = nil;
	dispatch_sync(serialQueue, ^{
		result = _failedError;
	});
	
	return result;
}

- (void) setFailedError:(NSError *)failedError {
	[self willChangeValueForKey:@"failedError"];
	[self willChangeValueForKey:@"progressMessage"];
	dispatch_sync(serialQueue, ^{
		_failedError = failedError;
		_progressMessage = [failedError localizedDescription];
	});
	[self didChangeValueForKey:@"progressMessage"];
	[self didChangeValueForKey:@"failedError"];
	
	[self notifyChanged];
}

- (void) addChild:(BMFProgress *) child {
    BMFAssertReturn([child isKindOfClass:[BMFProgress class]]);
	
	NSHashTable *children = self.children;
	dispatch_sync(serialQueue, ^{
		[children addObject:child];
	});
	
	child.progressChangedBlock = ^(BMFProgress *child) {
		[self updateValuesFromChildren];
	};
	
	[self updateValuesFromChildren];
}

- (void) removeChild:(BMFProgress *) child {
	if (!child) {
		return;
	}
	
	NSHashTable *children = self.children;
	dispatch_sync(serialQueue, ^{
		[children removeObject:child];
	});
	
	child.progressChangedBlock = nil;
}

- (void) start:(NSString *) key {
	self.key = key;
	[self start];
}

- (void) start {
	
	BMFAssertReturn(self.key.length>0);
	BMFAssertReturn(self.children.count==0);

	[self clear];
	
	[BMFAverageTime startTime:self.key effort:self.totalUnitCount sender:self];

	self.running = YES;
}

- (void) stop: (NSError *) error {
	BMFAssertReturn(self.children.count==0);

	if (self.key && self.running) {
		if (error) [BMFAverageTime cancelTime:self.key];
		else [BMFAverageTime stopTime:self.key sender:self];
		
		self.key = nil;
	}
	else {
		/// If we are running without a key something is wrong. We should always be started with a key
		BMFAssertReturn(!self.running);
	}
	
    self.running = NO;
    
	self.completedUnitCount = self.totalUnitCount;
	self.failedError = error;
}

- (void) dealloc {
	[self clear];
}

- (NSString *) description {
	return [NSString stringWithFormat:@"<%@: %p, %@>",[self class],self,@{
																		  @"running" : @(_running),
																		  @"total" : @(_totalUnitCount),
																		  @"completed" : @(_completedUnitCount),
																		  @"estimated time" : @(_estimatedTime),
																		  @"message" : [NSString BMF_nonNilString:_progressMessage],
																		  @"error" : [BMFUtils objectOrNull:_failedError]
																		  }];
}

@end
