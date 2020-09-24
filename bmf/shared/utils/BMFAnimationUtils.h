//
//  BMFAnimationUtils.h
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/01/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMFAnimationUtils : NSObject

+ (void) blinkOnce:(CALayer *) layer interval:(NSTimeInterval) interval;
+ (void) startBlinking:(CALayer *) layer interval:(NSTimeInterval) interval;
+ (void) stopBlinking:(CALayer *) layer;
+ (BOOL) isBlinking:(CALayer *) layer;

/// The strength used will be 0.05
+ (void) harlemShake:(CALayer *) layer vibrate:(BOOL) vibrate;

+ (void) harlemShake:(CALayer *) layer strength:(CGFloat)strength vibrate:(BOOL) vibrate;

@end
