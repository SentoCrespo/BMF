//
//  BMFPopoverController.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 22/07/14.
//
//

#import <UIKit/UIKit.h>

#import "BMFTypes.h"

@interface BMFPopoverController : UIPopoverController

@property (nonatomic, weak) UIViewController *presentingViewController;

- (void) presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections inViewController:(UIViewController *) containerVC animated:(BOOL)animated;
- (void) presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections inViewController:(UIViewController *) containerVC animated:(BOOL)animated;

@end
