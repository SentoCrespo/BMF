//
//  BMFRunAlphaAnimationBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/11/14.
//
//

#import "BMFAlphaAnimationBehavior.h"

#import "BMF.h"

@implementation BMFAlphaAnimationBehavior

- (void) beforeAnimation {
	BMFAssertReturn(self.views.count>0);
	
	if (self.springInitialVelocity==-FLT_MAX) {
		CGFloat duration = self.duration;
		if (duration==0) duration = 0.001;
		self.springInitialVelocity = (self.finalValue-self.initialValue)/duration;
	}
	
	[self applyInitialValues:self];
}

- (IBAction)applyInitialValues:(id)sender {
	if (!self.enabled) return;
	
	for (UIView *view in self.views) {
		view.alpha = self.initialValue;
		[view setNeedsDisplay];
	}
}

- (IBAction)applyFinalValues:(id)sender {
	if (!self.enabled) return;
	
	for (UIView *view in self.views) {
		view.alpha = self.finalValue;
		[view setNeedsDisplay];
	}
}

- (void) performAnimation {
	for (UIView *view in self.views) {
		view.alpha = self.finalValue;
	}
}

@end
