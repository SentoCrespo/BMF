//
//  BMFCircularView.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 13/3/15.
//
//

#import "BMFCircularView.h"

#import "BMFAutoLayoutUtils.h"

@implementation BMFCircularView

- (void) performInit {
	[super performInit];
	
	[BMFAutoLayoutUtils makeSquare:self];
	
	self.clipsToBounds = YES;
	[self p_updateCorners];
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	[self p_updateCorners];
}

- (void) p_updateCorners {
	self.layer.cornerRadius = self.frame.size.width/2;
}

@end
