//
//  BMFControlScaleAspect.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/06/14.
//
//

#import "BMFControlScaleAspect.h"

#import "BMF.h"

@implementation BMFControlScaleAspect

- (instancetype) init {
	self = [super init];
	if (self) {
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
		
		control.transform = CGAffineTransformMakeScale(0.1, 0.1);
		
		[UIView animateWithDuration:self.animationDuration delay:0 usingSpringWithDamping:self.damping initialSpringVelocity:self.springVelocity options:0 animations:^{
			control.transform = CGAffineTransformIdentity;
		} completion:nil];
	}
}

@end
