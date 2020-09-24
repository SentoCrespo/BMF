//
//  BMFScaleAnimationBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 19/11/14.
//
//

#import "BMFRunAnimationBehavior.h"

@interface BMFScaleAnimationBehavior : BMFRunAnimationBehavior<BMFViewsAnimationBehaviorProtocol>


@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *views;

@property (nonatomic, assign) IBInspectable CGPoint initialValue;
@property (nonatomic, assign) IBInspectable CGPoint finalValue;

- (IBAction)applyInitialValues:(id)sender;
- (IBAction)applyFinalValues:(id)sender;

@end
