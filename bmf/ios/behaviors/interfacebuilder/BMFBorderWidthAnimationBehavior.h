//
//  BMFBorderWidthAnimationBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/12/14.
//
//

#import "BMFLayerAnimationBehavior.h"

@interface BMFBorderWidthAnimationBehavior : BMFLayerAnimationBehavior

@property (nonatomic, assign) IBInspectable CGFloat initialWidth;
@property (nonatomic, assign) IBInspectable CGFloat finalWidth;

- (IBAction)applyInitialValues:(id)sender;
- (IBAction)applyFinalValues:(id)sender;

@end
