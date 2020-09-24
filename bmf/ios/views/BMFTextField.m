//
//  BMFTextField.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/10/14.
//
//

#import "BMFTextField.h"

@implementation BMFTextField

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
	self.BMF_contentInset = CGPointMake(10, 5);
}


// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
	[super textRectForBounds:bounds];
	return CGRectInset(bounds, self.BMF_contentInset.x, self.BMF_contentInset.y);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
	[super editingRectForBounds:bounds];
	return [self textRectForBounds:bounds];
}

@end
