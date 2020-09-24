//
//  BMFEaseUtils.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 02/06/14.
//
//

#import <Foundation/Foundation.h>

@interface BMFEaseUtils : NSObject

+ (CGFloat) quadraticEaseIn:(CGFloat) value;
+ (CGFloat) quadraticEaseOut:(CGFloat) value;

+ (CGFloat) cubicEaseIn:(CGFloat) value;
+ (CGFloat) cubicEaseOut:(CGFloat) value;

+ (CGFloat) quarticEaseIn:(CGFloat) value;
+ (CGFloat) quarticEaseOut:(CGFloat) value;

+ (CGFloat) circularEaseIn:(CGFloat) value;
+ (CGFloat) circularEaseOut:(CGFloat) value;

@end
