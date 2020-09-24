//
//  BMFShakeAnimationBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/11/14.
//
//

#import "BMFShakeAnimationBehavior.h"

#import "BMF.h"
#import "BMFAnimationUtils.h"

@implementation BMFShakeAnimationBehavior

- (void) performAnimation {
	if (self.strength==0) self.strength = 0.05;
	
	for (UIView *view in self.views) {
		[BMFAnimationUtils harlemShake:view.layer strength:self.strength vibrate:self.vibrate];
	}
}

@end
