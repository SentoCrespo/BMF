//
//  BMFRunAnimationBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/11/14.
//
//

#import <UIKit/UIKit.h>

#import "BMFAnimationBehaviorProtocols.h"
#import "BMFViewControllerBehavior.h"
#import "BMFBehaviorsViewControllerProtocol.h"

IB_DESIGNABLE
@interface BMFRunAnimationBehavior : BMFViewControllerBehavior <BMFAnimationBehaviorProtocol>

@property (nonatomic, assign) IBInspectable CGFloat duration;

/// 0.0 by default
@property (nonatomic, assign) IBInspectable CGFloat delay;

/// NO by default
@property (nonatomic, assign) IBInspectable BOOL repeat;

/// NO by default
@property (nonatomic, assign) IBInspectable BOOL autoreverse;

/// YES by default
@property (nonatomic, assign) IBInspectable BOOL beginFromCurrentPostion;

@property (nonatomic, assign) IBInspectable CGFloat springDamping;

@property (nonatomic, assign) IBInspectable CGFloat springInitialVelocity;

/// Might be: @"linear", @"easein", @"easeout", @"easeinout"
@property (nonatomic, copy) IBInspectable NSString *animationType;

@property (nonatomic, readonly) UIViewAnimationOptions animationOptions;

- (IBAction)runAnimation:(id)sender;

// Template methods
- (void) beforeAnimation;
- (void) performAnimation;
- (void) afterAnimation __attribute((objc_requires_super));

@end
