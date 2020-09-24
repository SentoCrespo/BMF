//
//  BMFAppearTriggerBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/11/14.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFAppearTriggerBehavior : BMFViewControllerBehavior

/// NO by default. If YES the actions will be run before the view is shown
@property (nonatomic, assign) IBInspectable BOOL beforeAppear;

/// Do this only the first time the view appears or always
@property (nonatomic, assign) IBInspectable BOOL onlyOnce;
@property (nonatomic, assign) IBInspectable CGFloat delay;

/// YES by default. Defines if the trigger will fire if the navigation direction is forward
@property (nonatomic, assign) IBInspectable BOOL triggerForward;
/// YES by default. Defines if the trigger will fire if the navigation direction is backward
@property (nonatomic, assign) IBInspectable BOOL triggerBackward;

@end
