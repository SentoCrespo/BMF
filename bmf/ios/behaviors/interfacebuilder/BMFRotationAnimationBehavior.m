//
//  BMFRotationAnimationBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 19/11/14.
//
//

#import "BMFRotationAnimationBehavior.h"

#import "BMF.h"

@implementation BMFRotationAnimationBehavior

- (void) beforeAnimation {
	BMFAssertReturn(self.views.count>0);
	
	if (self.springInitialVelocity==-FLT_MAX) {
		CGFloat duration = self.duration;
		if (duration==0) duration = 0.001;
		self.springInitialVelocity = (self.finalValue-self.initialValue)/duration;
	}
	
	for (UIView *view in self.views) {
		view.transform = CGAffineTransformMakeRotation(BMF_DEGREES_TO_RADIANS(self.initialValue));
	}
}

- (void) performAnimation {
	for (UIView *view in self.views) {
		view.transform = CGAffineTransformMakeRotation(BMF_DEGREES_TO_RADIANS(self.finalValue));
	}
}

- (IBAction)applyInitialValues:(id)sender {
	if (!self.enabled) return;
	
	for (UIView *view in self.views) {
		view.transform = CGAffineTransformMakeRotation(BMF_DEGREES_TO_RADIANS(self.initialValue));
	}
}

- (IBAction)applyFinalValues:(id)sender {
	if (!self.enabled) return;
	
	for (UIView *view in self.views) {
		view.transform = CGAffineTransformMakeRotation(BMF_DEGREES_TO_RADIANS(self.finalValue));
	}
}

@end
