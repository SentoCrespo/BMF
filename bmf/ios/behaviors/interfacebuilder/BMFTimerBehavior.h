//
//  BMFTimerBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 13/2/15.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFTimerBehavior : BMFViewControllerBehavior

@property (nonatomic, assign) IBInspectable float interval;

/// Runs the action on view will appear. YES by default
@property (nonatomic, assign) IBInspectable BOOL actionOnWillAppear;


@end
