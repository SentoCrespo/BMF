//
//  BMFPopoverController.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 22/07/14.
//
//

#import "BMFPopoverController.h"

#import "UIViewController+BMF.h"

@interface BMFPopoverController()

@end

@implementation BMFPopoverController

- (instancetype) initWithContentViewController:(UIViewController *)viewController {
	self = [super initWithContentViewController:viewController];
	if (self) {
		self.delegate = (id)self;
	}
	return self;
}

- (void) presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated {
	[NSException raise:@"Invalid method" format:@"Use presentPopoverFromBarButtonItem:permittedArrowDirections:inViewController:animated instead"];
}


/// UIPopoverController calls this method from the other one
- (void) presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated {
	if (!self.presentingViewController) {
		[NSException raise:@"Invalid method" format:@"Use presentPopoverFromRect:inView:permittedArrowDirections:inViewController:animated instead"];
	}
	[super presentPopoverFromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];
}


- (void) presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections inViewController:(UIViewController *) containerVC animated:(BOOL)animated {
	self.presentingViewController = containerVC;
	self.contentViewController.BMF_popoverController = self;
	[super presentPopoverFromBarButtonItem:item permittedArrowDirections:arrowDirections animated:animated];
}

- (void) presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections inViewController:(UIViewController *) containerVC animated:(BOOL)animated {
	self.presentingViewController = containerVC;
	self.contentViewController.BMF_popoverController = self;
	[super presentPopoverFromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];
}

@end
