//
//  BMFRunConstraintAnimationBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/11/14.
//
//

#import "BMFRunAnimationBehavior.h"

IB_DESIGNABLE
/// Animates a view by changing the constraint constant
@interface BMFConstraintAnimationBehavior : BMFRunAnimationBehavior

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constraint;

@property (nonatomic, assign) IBInspectable CGFloat initialValue;
@property (nonatomic, assign) IBInspectable CGFloat finalValue;

- (IBAction)applyInitialValues:(id)sender;
- (IBAction)applyFinalValues:(id)sender;

@end
