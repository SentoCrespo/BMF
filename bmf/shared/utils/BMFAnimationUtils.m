//
//  BMFAnimationUtils.m
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/01/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import "BMFAnimationUtils.h"

#import "BMFTypes.h"

#import <QuartzCore/QuartzCore.h>

#import <AudioToolbox/AudioServices.h>

BMFLocalConstant(NSString *, BMFBlinkAnimationKey, @"Blinking")
BMFLocalConstant(NSString *, BMFHarlemShakeAnimationKey, @"HarlemShake")

@implementation BMFAnimationUtils

+ (void) blink:(CALayer *) layer interval:(NSTimeInterval) interval repeatCount:(NSInteger)repeatCount {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[animation setFromValue:[NSNumber numberWithFloat:1.0]];
	[animation setToValue:[NSNumber numberWithFloat:0.0]];
	[animation setDuration:interval];
	[animation setTimingFunction:[CAMediaTimingFunction
								  functionWithName:kCAMediaTimingFunctionLinear]];
	[animation setAutoreverses:YES];
	[animation setRepeatCount:repeatCount];
	[layer addAnimation:animation forKey:BMFBlinkAnimationKey];
}

+ (void) blinkOnce:(CALayer *) layer interval:(NSTimeInterval) interval {
	[self blink:layer interval:interval repeatCount:0];
}

+ (void) startBlinking:(CALayer *) layer interval:(NSTimeInterval) interval {
	[self blink:layer interval:interval repeatCount:HUGE_VALF];
}

+ (void) stopBlinking:(CALayer *) layer {
	[layer removeAnimationForKey:BMFBlinkAnimationKey];
}

+ (BOOL) isBlinking:(CALayer *) layer {
	return [layer animationForKey:BMFBlinkAnimationKey]!=nil;
}

+ (void) harlemShake:(CALayer *) layer vibrate:(BOOL) vibrate {
	[self harlemShake:layer strength:0.05 vibrate:vibrate];
}

+ (void) harlemShake:(CALayer *) layer strength:(CGFloat)strength vibrate:(BOOL) vibrate {
	CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	[anim setToValue:[NSNumber numberWithFloat:-strength]];
	[anim setFromValue:[NSNumber numberWithFloat:strength]];
	[anim setDuration:0.09f];
	[anim setRepeatCount:2];
	[anim setAutoreverses:YES];

	layer.shouldRasterize = NO;
	[layer addAnimation:anim forKey:BMFHarlemShakeAnimationKey];
	
	#if TARGET_OS_IPHONE
	if (vibrate) AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	#endif
}

@end
