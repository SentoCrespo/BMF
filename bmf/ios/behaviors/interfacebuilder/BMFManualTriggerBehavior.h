//
//  BMFManualTriggerBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/3/15.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFManualTriggerBehavior : BMFViewControllerBehavior

@property (nonatomic, assign) IBInspectable CGFloat delay;

- (IBAction)fire:(id)sender;

@end
