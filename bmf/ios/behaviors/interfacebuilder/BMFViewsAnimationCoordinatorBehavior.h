//
//  BMFViewsAnimationCoordinatorBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/12/14.
//
//

#import "BMFRunAnimationBehavior.h"

@interface BMFViewsAnimationCoordinatorBehavior : BMFRunAnimationBehavior<BMFViewsAnimationBehaviorProtocol>

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *views;
@property (nonatomic, strong) IBOutletCollection(UIControl) NSArray *animations;

@end
