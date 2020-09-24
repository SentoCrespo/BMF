//
//  ExampleHomeScreenItemConfigurator.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 16/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "ExampleHomeScreenItemConfigurator.h"

#import "BMFHomeScreenItemCell.h"

@implementation ExampleHomeScreenItemConfigurator

+ (void) load {
	[self register];
}

+ (Class) itemClass {
	return [NSString class];
}

+ (Class) viewClass {
	return [BMFHomeScreenItemCell class];
}

+ (void) configure:(id)view kind:(NSString *)kind withItem:(id)item inView:(UIView *)containerView atIndexPath:(NSIndexPath *)indexPath controller:(id)controller {
	BMFHomeScreenItemCell *cell = view;
	cell.item.textLabel.text = item;
}

@end
