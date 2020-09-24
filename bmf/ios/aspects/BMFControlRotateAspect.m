//
//  BMFControlRotateAspect.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/06/14.
//
//

#import "BMFControlRotateAspect.h"

#import "BMF.h"

@implementation BMFControlRotateAspect

- (instancetype) init {
	self = [super init];
	if (self) {
		_angle = 90;
		_mode = BMFControlRotateAspectModeOnce;
		_animationDuration = 0.2;
		_damping = 0.95;
		_springVelocity = 0.05;
	}
	return self;
}

- (void) setObject:(id)object {
	BMFAssertReturn([object respondsToSelector:@selector(setHighlighted:)]);
	BMFAssertReturn([object respondsToSelector:@selector(setTransform:)]);
	
	[super setObject:object];
}

- (void) setHighlighted:(BOOL) highlighted {
	if (highlighted) {
		UIControl *control = self.object;
		
		if (control.frame.size.width!=control.frame.size.height) {
			DDLogWarn(@"Control is not square, rotation animation will not be centered");
		}
		
		[UIView animateWithDuration:self.animationDuration delay:0 usingSpringWithDamping:self.damping initialSpringVelocity:self.springVelocity options:0 animations:^{
			if (_mode==BMFControlRotateAspectModeToggle && !CGAffineTransformIsIdentity(control.transform)) {
				control.transform = CGAffineTransformIdentity;
			}
			else control.transform = CGAffineTransformMakeRotation(BMF_DEGREES_TO_RADIANS(_angle));
		} completion:^(BOOL finished){
			if (_mode==BMFControlRotateAspectModeOnce) control.transform = CGAffineTransformIdentity;
		}];
	}
}

@end
