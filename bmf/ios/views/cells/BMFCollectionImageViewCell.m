//
//  BMFCollectionImageViewCell.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/02/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFCollectionImageViewCell.h"

#import "BMFAutoLayoutUtils.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation BMFCollectionImageViewCell

- (void) performInit {
	[super performInit];
	
	self.imageView = [UIImageView new];
	self.imageView.userInteractionEnabled = NO;
	[self.contentView addSubview:self.imageView];
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	self.imageView.clipsToBounds = YES;
	[BMFAutoLayoutUtils fill:self.contentView with:self.imageView margin:0];
}

@end
