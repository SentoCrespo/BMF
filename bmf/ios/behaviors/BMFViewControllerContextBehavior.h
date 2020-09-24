//
//  BMFViewControllerContextBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/07/14.
//
//

#import "BMFViewControllerBehavior.h"

#import "BMFViewControllerContext.h"

typedef void(^BMFViewControllerContextPrepareBlock)(BMFViewControllerContext *context);
typedef void(^BMFViewControllerContextApplyBlock)(BMFViewControllerContext *context,UIViewController *vc);


/// IMPORTANT: If you want this behavior to work for embedded segues you have to add it in the init methods. viewDidLoad it is too late!
@interface BMFViewControllerContextBehavior : BMFViewControllerBehavior

/// Optional. Use this to make specific configurations in the context before applying it to the view controller, such as manually setting the detailItem
@property (nonatomic, copy) BMFViewControllerContextPrepareBlock prepareBlock;

/// Optional. Use this to pass parameters in a specific view controller, as opposed to parameters used by most of the view controllers of the app
@property (nonatomic, copy) BMFViewControllerContextApplyBlock applyBlock;

/// Subclass and change this method to add more properties to pass
- (BMFViewControllerContext *) newContextWithViewController:(UIViewController *) viewController;

/// If you aren't using a storyboard segue you must use this method to apply the context to the next view controller
- (void) applyTo:(UIViewController *) destinationVC;

/// You can use this method to apply this context to all the childViewControllers, for example
- (void) applyToViewControllers:(NSArray *) viewControllers;

@end
