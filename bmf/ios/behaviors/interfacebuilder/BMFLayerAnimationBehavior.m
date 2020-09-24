//
//  BMFLayerAnimationBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/12/14.
//
//

#import "BMFLayerAnimationBehavior.h"

@interface BMFLayerAnimationBehavior ()

@property (nonatomic, assign) NSUInteger animationsFinished;

@end

@implementation BMFLayerAnimationBehavior

- (CAMediaTimingFunction *) timingFunction {
	NSString *timingFunctionName = kCAMediaTimingFunctionDefault;
	
	NSString *animType = self.animationType.lowercaseString;
	if ([animType isEqualToString:@"linear"]) {
		timingFunctionName = kCAMediaTimingFunctionLinear;
	}
	else if ([animType isEqualToString:@"easein"]) {
		timingFunctionName = kCAMediaTimingFunctionEaseIn;
	}
	else if ([animType isEqualToString:@"easeout"]) {
		timingFunctionName = kCAMediaTimingFunctionEaseOut;
	}
	else {
		timingFunctionName = kCAMediaTimingFunctionEaseInEaseOut;
	}
	
	return [CAMediaTimingFunction functionWithName:timingFunctionName];
}

- (IBAction)runAnimation:(id)sender {
	if (!self.isEnabled) return;

	self.animationsFinished = 0;
	
	[self beforeAnimation];
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:self.keyPath];
	animation.timingFunction = [self timingFunction];
	animation.fromValue = [self initialValue];
	animation.toValue = [self finalValue];
	animation.duration = self.duration;
	animation.repeatCount = self.repeat? HUGE_VALF : 0;
//	animation.fillMode = kCAFillModeForwards;
//	animation.removedOnCompletion = NO;
	
	animation.delegate = self;
	
	for (UIView *view in self.views) {
		[view.layer addAnimation:animation forKey:self.keyPath];
		[view.layer setValue:[self finalValue] forKey:self.keyPath];
	}
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	if (flag) {
		
//		for (UIView *view in self.views) {
//			CAAnimation *layerAnim = [view.layer animationForKey:self.keyPath];
//			if (layerAnim==anim || ![view.layer animationKeys]) {
//				[view.layer setValue:self.finalValue forKey:self.keyPath];
//			}
//		}
		
		self.animationsFinished++;
		if (self.animationsFinished==self.views.count) {
			self.animationsFinished = 0;
			[self afterAnimation];
		}
	}
}

@end
