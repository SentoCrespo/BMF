//
//  UIButton+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/7/15.
//
//

#import "UIButton+BMF.h"

@implementation UIButton (BMF)

- (void) setBMF_title:(NSString *)BMF_title {
	[self setTitle:BMF_title forState:UIControlStateNormal];
}

- (NSString *) BMF_title {
	return [self titleColorForState:UIControlStateNormal];
}

@end
