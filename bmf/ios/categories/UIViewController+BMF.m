//
//  UIViewController+BMFUtils.m
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/01/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import "UIViewController+BMF.h"

#import "BMFPopoverController.h"

#import <objc/runtime.h>

@implementation UIViewController (BMF)

@dynamic BMF_popoverController;

- (void) BMF_addChild:(UIViewController *) detailVC addSubviewBlock:(BMFActionBlock) block {
	BMFAssertReturn(block);

	[self addChildViewController:detailVC];
	
	if (block) block(self);
	
	[detailVC didMoveToParentViewController:self];
}

- (void) BMF_removeFromParent {
	[self willMoveToParentViewController:nil];
	[self.view removeFromSuperview];
	[self removeFromParentViewController];
}

- (BMFPopoverController *) BMF_popoverController {
	return objc_getAssociatedObject(self, @selector(BMF_popoverController));
}

- (void) setBMF_popoverController:(BMFPopoverController *)BMF_popoverController {
	objc_setAssociatedObject(self, @selector(BMF_parentViewController), BMF_popoverController, OBJC_ASSOCIATION_RETAIN);
}

- (void) BMF_popToRootViewController {
	if (self.BMF_popoverController) {
		[self.BMF_popoverController dismissPopoverAnimated:NO];
		UIViewController *presentingVC = self.BMF_popoverController.presentingViewController;
		self.BMF_popoverController = nil;
		[self bmf_popViewController:presentingVC];
	}
	else {
		[self bmf_popViewController:self];
	}
}

- (void) bmf_popViewController: (UIViewController *) vc {
	if (!vc) return;
	
	if (vc.presentingViewController) {
		[vc.presentingViewController dismissViewControllerAnimated:YES completion:^{
			[self bmf_popViewController:vc];
		}];
		return;
	}
	
	if (vc.navigationController) {
		[vc.navigationController popToRootViewControllerAnimated:YES];
		vc = vc.navigationController.viewControllers.firstObject;
	}
	
	if (vc.parentViewController) {
		[self bmf_popViewController:vc.parentViewController];
	}
}

- (UIViewController *) BMF_viewControllerDefiningContext {
	UIViewController *vc = self;
	while (!vc.definesPresentationContext) {
		if (vc.parentViewController) vc = vc.parentViewController;
		else if (vc.presentingViewController) vc = vc.presentingViewController;
		else return vc;
	}
	
	return vc;
}

- (UIViewController *) BMF_parentViewController {
	return [self BMF_extractParentViewController:self.parentViewController];
}

- (UIViewController *) BMF_extractParentViewController:(UIViewController *) vc {
	if (!vc) return nil;
	
	if ([vc isKindOfClass:[UINavigationController class]]) {
		vc = vc.parentViewController;
	}
	
	if (vc) return vc;
	
//	if ([vc isKindOfClass:[UITabBarController class]]) {
//		vc = vc.parentViewController;
//	}
	
	return [self BMF_extractParentViewController:vc];
}

@end
