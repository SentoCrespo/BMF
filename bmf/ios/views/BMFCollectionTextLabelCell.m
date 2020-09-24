//
//  BMFCollectionTextLabelCell.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/3/15.
//
//

#import "BMFCollectionTextLabelCell.h"

#import "BMFAutoLayoutUtils.h"

@implementation BMFCollectionTextLabelCell

- (void) performInit {
	[super performInit];
	
	self.textLabel = [UILabel new];
	[self.contentView addSubview:self.textLabel];
	self.textLabel.numberOfLines = 0;
	self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	[BMFAutoLayoutUtils fill:self.contentView with:self.textLabel margin:0];
}

@end
