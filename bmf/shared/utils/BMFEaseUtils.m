//
//  BMFEaseUtils.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 02/06/14.
//
//

#import "BMFEaseUtils.h"

@implementation BMFEaseUtils

+ (CGFloat) quadraticEaseIn:(CGFloat) value {
	return value*value;
}

+ (CGFloat) quadraticEaseOut:(CGFloat) value {
	return -value*(value-2);
}

+ (CGFloat) cubicEaseIn:(CGFloat) value {
	return value*value*value;
}

+ (CGFloat) cubicEaseOut:(CGFloat) value {
	value--;
	return value*value*value+1;
}

+ (CGFloat) quarticEaseIn:(CGFloat) value {
	value *= value;
	return value*value;
}

+ (CGFloat) quarticEaseOut:(CGFloat) value {
	value--;
	value *= value;
	return -(value*value-1);
}

+ (CGFloat) circularEaseIn:(CGFloat) value {
	return -(sqrt(1 - value*value) - 1);
}

+ (CGFloat) circularEaseOut:(CGFloat) value {
	value--;
	return (sqrt(1 - value*value));
}

@end
