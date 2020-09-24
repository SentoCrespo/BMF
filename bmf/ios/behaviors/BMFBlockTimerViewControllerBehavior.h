//
//  BMFBlockTimerViewControllerBehavior.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFViewControllerBehavior.h"

#import "BMFTypes.h"

@interface BMFBlockTimerViewControllerBehavior : BMFViewControllerBehavior

@property (nonatomic, assign) float interval;

/// The view controller is passed here
@property (nonatomic, copy) BMFActionBlock actionBlock;

/// Runs the action on view will appear. YES by default
@property (nonatomic, assign) BOOL actionOnWillAppear;

/// YES by default. Set to false to stop the timer behavior
//@property (nonatomic, assign) BOOL enabled;

- (instancetype) initWithActionBlock:(BMFActionBlock) block interval:(float) interval;
- (instancetype) init __attribute__((unavailable("Use initWithActionBlock:interval: instead")));

@end
