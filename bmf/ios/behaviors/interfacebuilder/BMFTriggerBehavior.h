//
//  BMFTriggerBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/11/14.
//
//

#import "BMFViewControllerBehavior.h"

IB_DESIGNABLE
@interface BMFTriggerBehavior : BMFViewControllerBehavior

@property (nonatomic, assign) IBInspectable CGFloat delay;

- (IBAction)fire:(id)sender;

@end
