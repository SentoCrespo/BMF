//
//  BMFRunAnimationBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/11/14.
//
//

#import "BMFRunAnimationBehavior.h"

#import "BMF.h"

@implementation BMFRunAnimationBehavior

- (void) performInit {
	[super performInit];
	
	_duration = 0.5;
	_delay = 0.0;
	_beginFromCurrentPostion = YES;
	_animationType = @"easeinout";
	
	_springDamping = 1;
	_springInitialVelocity = 10;
}

- (UIViewAnimationOptions) animationOptions {
	UIViewAnimationOptions options = 0;
	if (self.repeat) options |= UIViewAnimationOptionRepeat;
	if (self.autoreverse) options |= UIViewAnimationOptionAutoreverse;
	if (self.beginFromCurrentPostion) options |= UIViewAnimationOptionBeginFromCurrentState;
	
	NSString *animType = self.animationType.lowercaseString;
	if ([animType isEqualToString:@"linear"]) {
		options |= UIViewAnimationOptionCurveLinear;
	}
	else if ([animType isEqualToString:@"easein"]) {
		options |= UIViewAnimationOptionCurveEaseIn;
	}
	else if ([animType isEqualToString:@"easeout"]) {
		options |= UIViewAnimationOptionCurveEaseOut;
	}
	else {
		options |= UIViewAnimationOptionCurveEaseInOut;
	}
	
	return options;
}

- (IBAction)runAnimation:(id)sender {
	if (!self.isEnabled) return;
	
	[self beforeAnimation];
	
	[UIView animateWithDuration:self.duration delay:self.delay usingSpringWithDamping:self.springDamping initialSpringVelocity:self.springInitialVelocity options:self.animationOptions animations:^{
		[self performAnimation];
	} completion:^(BOOL finished) {
		[self afterAnimation];
	}];
}

#pragma mark Template methods

- (void) beforeAnimation { }

- (void) performAnimation { }

- (void) afterAnimation {
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
