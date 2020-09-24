//
//  ExampleHeaderView.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 04/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "ExampleHeaderView.h"

#import "BMF.h"

@implementation ExampleHeaderView

- (void) performInit {
	[super performInit];
	
	self.contentView.backgroundColor = [UIColor redColor];
	
	self.label = [UILabel new];
	self.label.textAlignment = BMFTextAlignmentCenter;
	
	[self.contentView addSubview:self.label];
	[BMFAutoLayoutUtils fill:self.contentView with:self.label margin:0];
}

@end
