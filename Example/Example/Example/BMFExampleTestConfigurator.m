//
//  BMFExampleTestConfigurator.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 02/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFExampleTestConfigurator.h"

@implementation BMFExampleTestConfigurator

+ (void) load {
	[self register];
}

+ (Class) viewClass {
	return [UITableViewCell class];
}

+ (Class) itemClass {
	return [NSString class];
}

+ (void) configure:(id)view kind:(NSString *)kind withItem:(id)item inView:(UIView *)containerView atIndexPath:(NSIndexPath *)indexPath controller:(id)controller {
	UITableViewCell *cell = view;
	cell.textLabel.text = item;
}

/*
+ (CGFloat) heightOf:(id)cell kind:(BMFViewKind)kind withItem:(NSString *)item inView:(UIView *)containerView atIndexPath:(NSIndexPath *)indexPath {
	return item.length*20;
}*/

@end
