//
//  BMFPopNavigationControllerBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/1/15.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFPopNavigationControllerBehavior : BMFViewControllerBehavior

/// YES by default
@property (nonatomic, assign) IBInspectable BOOL animated;

- (IBAction)popViewController:(id)sender;
- (IBAction)popToRootViewController:(id)sender;

@end
