//
//  BMFDelayActionBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 4/12/14.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFDelayActionBehavior : BMFViewControllerBehavior

@property (nonatomic, assign) IBInspectable double delay;

- (IBAction)run:(id)sender;

@end
