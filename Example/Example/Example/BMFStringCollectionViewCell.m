//
//  BMFStringCollectionViewCell.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/08/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFStringCollectionViewCell.h"

#import <BMF/BMF.h>

@implementation BMFStringCollectionViewCell

@synthesize label = _label;

- (void) performInit {
	[super performInit];
	
	UILabel *mainLabel = [UILabel new];
	[self.contentView addSubview:mainLabel];
	[BMFAutoLayoutUtils fill:self.contentView with:mainLabel margin:0];
	self.label = mainLabel;
	self.label.adjustsFontSizeToFitWidth = YES;
	self.label.minimumScaleFactor = 0.5;
	
	self.contentView.backgroundColor = [UIColor whiteColor];
}

@end
