//
//  BMFDisableDragToPopViewControllerBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 08/09/14.
//
//

#import "BMFDisableDragToPopViewControllerBehavior.h"

#import "BMF.h"

@interface BMFDisableDragToPopViewControllerBehavior()

@property (nonatomic, assign) BOOL wasEnabled;

@end

@implementation BMFDisableDragToPopViewControllerBehavior

- (void) viewDidAppear:(BOOL)animated {
	if (!self.isEnabled) return;
	
	if (!self.object.navigationController) {
		BMFLogWarnC(BMFLogBehaviorContext,@"No navigation controller in BMFDisableDragToPopViewControllerBehavior %@",self.object);
		return;
	}
	
	if ([self.object.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
		self.wasEnabled = self.object.navigationController.interactivePopGestureRecognizer.enabled;
		self.object.navigationController.interactivePopGestureRecognizer.enabled = NO;
	}
}

- (void) viewWillDisappear:(BOOL)animated {
	if (!self.isEnabled) return;
	
	if (!self.object.navigationController) {
		return;
	}
	if ([self.object.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
		self.object.navigationController.interactivePopGestureRecognizer.enabled = self.wasEnabled;
	}
}

@end
