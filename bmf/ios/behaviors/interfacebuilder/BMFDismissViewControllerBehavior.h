//
//  BMFDismissViewControllerBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 16/3/15.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFDismissViewControllerBehavior : BMFViewControllerBehavior

@property (nonatomic, assign) IBInspectable BOOL animated;

- (IBAction)dismiss:(id)sender;

@end
