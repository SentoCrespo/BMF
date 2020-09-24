//
//  TRNCollectionViewCell.m
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 17/12/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFCollectionViewCell.h"

@implementation BMFCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self performInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self performInit];
    }
    return self;
}


/// Template method
- (void) performInit {
	
}

- (void) setDetailItem:(id)detailItem {
	[NSException raise:@"Not implemented" format:@"You must implement setDetailItem to fill the cell"];
}

- (UICollectionViewLayoutAttributes *) preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
	UICollectionViewLayoutAttributes *attributes = [layoutAttributes copy];
	
	self.frame = attributes.frame;
	[self setNeedsLayout];
	[self layoutIfNeeded];
	
	CGFloat wantedHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
	CGRect frame = self.frame;
	frame.size.height = wantedHeight;
	attributes.frame = frame;
	return attributes;
}

@end
