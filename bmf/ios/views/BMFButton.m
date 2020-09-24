//
//  BMFButton.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/06/14.
//
//

#import "BMFButton.h"

#import "BMF.h"

@implementation BMFButton

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


#pragma mark Template methods

- (void) performInit {
	
}

#pragma mark Aspects

- (void) setEnabled:(BOOL)enabled {
	[super setEnabled:enabled];

	if ([self.BMF_proxy respondsToSelector:@selector(setEnabled:)]) [(id)self.BMF_proxy setEnabled:enabled];
}

- (void) setSelected:(BOOL)selected {
	[super setSelected:selected];
	
	if ([self.BMF_proxy respondsToSelector:@selector(setSelected:)]) [(id)self.BMF_proxy setSelected:selected];
}

- (void) setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	
	if ([self.BMF_proxy respondsToSelector:@selector(setHighlighted:)]) [(id)self.BMF_proxy setHighlighted:highlighted];
}

- (CGRect) contentRectForBounds:(CGRect)bounds {
	if ([self.BMF_proxy respondsToSelector:@selector(contentRectForBounds:)]) return [(id)self.BMF_proxy contentRectForBounds:bounds];
	
	return [super contentRectForBounds:bounds];
}

@end
