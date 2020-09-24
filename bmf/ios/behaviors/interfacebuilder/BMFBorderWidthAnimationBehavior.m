//
//  BMFBorderWidthAnimationBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/12/14.
//
//

#import "BMFBorderWidthAnimationBehavior.h"

@implementation BMFBorderWidthAnimationBehavior

- (void) beforeAnimation {
	for (UIView *view in self.views) {
		view.layer.borderWidth = self.initialWidth;
	}
}

#pragma mark Template methods

- (id) initialValue {
	return @(self.initialWidth);
}

- (id) finalValue {
	return @(self.finalWidth);
}

- (NSString *) keyPath {
	return @"borderWidth";
}

- (IBAction)applyInitialValues:(id)sender {
	if (!self.enabled) return;
	
	for (UIView *view in self.views) {
		view.layer.borderWidth = self.initialWidth;
	}
}

- (IBAction)applyFinalValues:(id)sender {
	if (!self.enabled) return;
	
	for (UIView *view in self.views) {
		view.layer.borderWidth = self.finalWidth;
	}
}

@end
