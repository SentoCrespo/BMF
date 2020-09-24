//
//  UIView+BMF.m
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/01/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import "UIView+BMF.h"

@implementation UIView (BMF)

#pragma mark Inspectables

- (void) setCornerRadius:(CGFloat)cornerRadius {
	self.layer.cornerRadius = cornerRadius;
}

- (CGFloat) cornerRadius {
	return self.layer.cornerRadius;
}

- (void) setBorderWidth:(CGFloat)borderWidth {
	self.layer.borderWidth = borderWidth;
}

- (CGFloat) borderWidth {
	return self.layer.borderWidth;
}

- (void) setBorderColor:(UIColor *)borderColor {
	self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *) borderColor {
	return [UIColor colorWithCGColor:self.layer.borderColor];
}

#pragma mark Utility methods

- (void) BMF_removeAllGestureRecognizers {
	for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
		[self removeGestureRecognizer:gestureRecognizer];
	}
}

- (void) BMF_setSubviews:(NSArray *) views {
	[self BMF_removeAllSubviews];
	[self BMF_addSubviews:views];
}

- (void) BMF_addSubviews:(NSArray *) views {
	for (UIView *view in views) {
		[self addSubview:view];
	}
}

- (void) BMF_removeAllSubviews {
	for (UIView *view in self.subviews) {
		[view removeFromSuperview];
	}
}

- (void) BMF_removeAllExcept:(NSArray *) views {
	for (UIView *view in self.subviews) {
		if (![views containsObject:view]) [view removeFromSuperview];
	}
}

- (void) BMF_removeAllConstraints {
	[self BMF_removeAllConstraints:NO];
}

- (void) BMF_removeAllConstraints:(BOOL) recursive {
	[self removeConstraints:self.constraints];
	[self.superview BMF_RemoveConstraintsWithViews:@[ self ]];

	if (recursive) {
		for (UIView *view in self.subviews) {
			[view BMF_removeAllConstraints:YES];
		}
	}
}

- (void) BMF_RemoveConstraintsWithViews:(NSArray *) subviews {
	NSMutableArray *constraintsToRemove = [NSMutableArray array];
	for (NSLayoutConstraint *constraint in self.constraints) {
		if ([subviews containsObject:constraint.firstItem] || [subviews containsObject:constraint.secondItem]) {
			[constraintsToRemove addObject:constraint];
		}
	}
	
	[self removeConstraints:constraintsToRemove];
}

- (UIView *) BMF_findSuperviewWithClass:(Class) viewClass {
	
	while (self.superview) {
		UIView *view = self.superview;
		if ([view isKindOfClass:viewClass]) {
			return view;
		}
	}
	
	return nil;
}

- (void) BMF_setAutolayoutIdentifier:(NSString *) identifier {
#if DEBUG
	SEL selectorName = NSSelectorFromString(@"_setLayoutDebuggingIdentifier:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	if ([self respondsToSelector:selectorName]) [self performSelector:selectorName withObject:identifier];
#pragma clang diagnostic pop
	#endif
}

- (BOOL) BMF_descendsFrom:(UIView *)view {
	if (!view) return NO;
	if (view==self.superview) return YES;
	return [view BMF_descendsFrom:view.superview];
}

- (BOOL) BMF_hasDescendant:(UIView *)view {
	if (!view) return NO;
	
	for (UIView *child in self.subviews) {
		if (child==view) return YES;
		if ([child BMF_hasDescendant:view]) return YES;
	}
	
	return NO;
}

@end
