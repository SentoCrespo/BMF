//
//  BMFShakeAnimationBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/11/14.
//
//

#import "BMFRunAnimationBehavior.h"

@interface BMFShakeAnimationBehavior : BMFRunAnimationBehavior<BMFViewsAnimationBehaviorProtocol>

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *views;

@property (nonatomic, assign) IBInspectable CGFloat strength;
@property (nonatomic, assign) IBInspectable BOOL vibrate;

@end
