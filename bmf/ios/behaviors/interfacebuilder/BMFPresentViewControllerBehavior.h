//
//  BMFPresentViewControllerBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 22/1/15.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFPresentViewControllerBehavior : BMFViewControllerBehavior

@property (nonatomic, assign) IBInspectable BOOL animated;

@property (nonatomic, copy) IBInspectable NSString *className;
@property (nonatomic, copy) IBInspectable NSString *segueName;

- (IBAction)presentViewController:(id)sender;

@end
