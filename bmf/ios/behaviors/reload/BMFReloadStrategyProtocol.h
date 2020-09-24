//
//  BMFReloadStrategyProtocol.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/12/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"

typedef NS_ENUM(NSUInteger, BMFReloadStrategyEvent) {
	BMFReloadStrategyEventViewLoaded,
	BMFReloadStrategyEventViewAppear,
	BMFReloadStrategyEventViewDisappear,
	BMFReloadStrategyEventForeground,
	BMFReloadStrategyEventDidBecomeActive,
	BMFReloadStrategyEventDataConnectionStatusChanged
};

@protocol BMFReloadStrategyProtocol <NSObject>

@property (nonatomic, copy) BMFActionBlock reloadBlock;

/// -1 by default, which means that it is not used. If it's >0 a timer will be set to trigger the reload every *reloadInterval* seconds
@property (nonatomic, assign) NSTimeInterval reloadInterval;

/// Minimum time between reloads. This avoids the problem of having several events triggering multiple downloads in a short span of time.
@property (nonatomic, assign) NSTimeInterval minimumReloadInterval;

- (void) handleEvent:(BMFReloadStrategyEvent)event;

- (void) loaded:(BOOL) success;

- (void) reload;

@end
