//
//  BMFGradientView.m
//  xinix
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/1/15.
//  Copyright (c) 2015 Treenovum. All rights reserved.
//

#import "BMFGradientView.h"

@interface BMFGradientView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation BMFGradientView

- (void) performInit {
	[super performInit];
	
	self.backgroundColor = [UIColor clearColor];
	
	self.gradientLayer = [CAGradientLayer layer];
	[self.layer addSublayer:self.gradientLayer];
	
	[self updateGradientLayer];
}

- (void) setStartColor:(UIColor *)startColor {
	_startColor = startColor;
	[self updateGradientLayer];
}

- (void) setEndColor:(UIColor *)endColor {
	_endColor = endColor;
	[self updateGradientLayer];
}

- (void) awakeFromNib {
	[super awakeFromNib];
	
	[self updateGradientLayer];
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	self.gradientLayer.frame = self.layer.bounds;
}

- (void) updateGradientLayer {
	if (!self.startColor || !self.endColor) return;
	
	self.gradientLayer.colors = @[ (id)self.startColor.CGColor, (id)self.endColor.CGColor ];
}

@end
