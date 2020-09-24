//
//  BMFScaleAnimationBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 19/11/14.
//
//

#import "BMFScaleAnimationBehavior.h"

#import "BMF.h"

@implementation BMFScaleAnimationBehavior

- (void) beforeAnimation {
	BMFAssertReturn(self.views.count>0);
	
	if (self.springInitialVelocity==-FLT_MAX) {
		CGFloat duration = self.duration;
		if (duration==0) duration = 0.001;
		self.springInitialVelocity = ( (self.finalValue.x-self.initialValue.x)+(self.finalValue.y-self.initialValue.y))/2*duration;
	}
	
	for (UIView *view in self.views) {
		view.transform = CGAffineTransformMakeScale(self.initialValue.x,self.initialValue.y);
	}
}

- (void) performAnimation {
	for (UIView *view in self.views) {
		view.transform = CGAffineTransformMakeScale(self.finalValue.x,self.finalValue.y);
	}
}


- (IBAction)applyInitialValues:(id)sender {
	if (!self.enabled) return;
	
	for (UIView *view in self.views) {
		view.transform = CGAffineTransformMakeScale(self.initialValue.x,self.initialValue.y);
	}
}

- (IBAction)applyFinalValues:(id)sender {
	if (!self.enabled) return;
	
	for (UIView *view in self.views) {
		view.transform = CGAffineTransformMakeScale(self.finalValue.x,self.finalValue.y);
	}
}

@end
