//
//  BMFExampleHeaderConfigurator.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 04/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFExampleHeaderConfigurator.h"

#import "ExampleHeaderView.h"

@implementation BMFExampleHeaderConfigurator

+ (void) load{
	[self register];
}

+ (Class) viewClass {
	return [ExampleHeaderView class];
}

+ (Class) itemClass {
	return [NSString class];
}

+ (void) configure:(ExampleHeaderView *) view kind:(NSString *)kind withItem:(id)item inView:(UIView *)containerView atIndexPath:(NSIndexPath *)indexPath controller:(id)controller {
	view.label.text = @"Cabecera";
}


+ (CGFloat) heightOf:(id)cell kind:(NSString *)kind withItem:(NSString *)item inView:(UIView *)containerView atIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

@end
