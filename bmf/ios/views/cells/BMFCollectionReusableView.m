//
//  BMFCollectionReusableView.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/09/14.
//
//

#import "BMFCollectionReusableView.h"

@implementation BMFCollectionReusableView

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

@end
