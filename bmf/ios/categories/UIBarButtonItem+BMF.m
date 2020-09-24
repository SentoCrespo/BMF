//
//  UIBarButtonItem+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/2/15.
//
//

#import "UIBarButtonItem+BMF.h"

@implementation UIBarButtonItem (BMF)

+ (UIBarButtonItem *) BMF_flexibleSpace {
	return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

+ (UIBarButtonItem *) BMF_fixedSpace {
	return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
}


@end
