//
//  BMFRunConstraintAnimationBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/11/14.
//
//

#import "BMFConstraintAnimationBehavior.h"

#import "BMF.h"

@implementation BMFConstraintAnimationBehavior

- (void) beforeAnimation {
	BMFAssertReturn(self.constraint);
	
	if (self.springInitialVelocity==-FLT_MAX) {
		CGFloat duration = self.duration;
		if (duration==0) duration = 0.001;
		self.springInitialVelocity = (self.finalValue-self.constraint.constant)/duration;
	}
	
	[UIView performWithoutAnimation:^{
		self.constraint.constant = self.initialValue;
		[self.object.view setNeedsUpdateConstraints];
		[self.object.view layoutSubviews];
	}];
	
	self.constraint.constant = self.finalValue;
}

- (void) performAnimation {
	[self.object.view layoutIfNeeded];
}

- (IBAction)applyInitialValues:(id)sender {
	if (!self.enabled) return;
	
	self.constraint.constant = self.initialValue;
	[self.object.view setNeedsUpdateConstraints];
	[self.object.view layoutSubviews];
}

- (IBAction)applyFinalValues:(id)sender {
	if (!self.enabled) return;
	
	self.constraint.constant = self.finalValue;
	[self.object.view setNeedsUpdateConstraints];
	[self.object.view layoutSubviews];
}


@end
