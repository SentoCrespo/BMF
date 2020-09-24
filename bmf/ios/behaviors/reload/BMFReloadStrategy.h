//
//  BMFReloadStrategy.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/12/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFReloadStrategyProtocol.h"

@interface BMFReloadStrategy : NSObject <BMFReloadStrategyProtocol>

@property (nonatomic, copy) BMFActionBlock reloadBlock;

/// -1 by default, which means that it is not used. If it's >0 a timer will be set to trigger the reload every *reloadInterval* seconds
@property (nonatomic, assign) NSTimeInterval reloadInterval;

/// Minimum time between reloads. This avoids the problem of having several events triggering multiple downloads in a short span of time. 1 second by default. This should only be used when a load has been successful
@property (nonatomic, assign) NSTimeInterval minimumReloadInterval;

// To be called by subclasses
- (void) startTimer;
- (void) stopTimer;
- (void) reload;

- (void) handleEvent:(BMFReloadStrategyEvent)event __attribute((objc_requires_super));
- (void) loaded:(BOOL) success __attribute((objc_requires_super));

- (instancetype) initWithReloadBlock:(BMFActionBlock) reloadBlock;

@end
