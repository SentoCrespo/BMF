//
//  BMFNavigateBackBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/12/14.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFNavigateBackBehavior : BMFViewControllerBehavior

@property (nonatomic, assign) IBInspectable BOOL animated;

- (IBAction)navigate:(id)sender;

@end
