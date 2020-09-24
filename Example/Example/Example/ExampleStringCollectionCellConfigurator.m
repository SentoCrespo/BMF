//
//  ExampleStringCollectionCellConfigurator.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/08/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "ExampleStringCollectionCellConfigurator.h"

#import "BMFStringCollectionViewCell.h"

@implementation ExampleStringCollectionCellConfigurator

+ (void) load {
	[self register];
}

+ (Class) itemClass  {
	return [NSString class];
}

+ (Class) viewClass {
	return [BMFStringCollectionViewCell class];
}

+ (void) configure:(id)view kind:(NSString *)kind withItem:(id)item inView:(UIView *)containerView atIndexPath:(NSIndexPath *)indexPath controller:(id)controller {
	
	BMFStringCollectionViewCell *cell = view;
	
	cell.label.text = item;
}

@end
