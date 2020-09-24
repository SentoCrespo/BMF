//
//  BMFContentSizeAspect.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/5/15.
//
//

#import "BMFContentSizeAspect.h"

#import "BMF.h"

@interface BMFContentSizeAspect()  <UIScrollViewDelegate>

@end

@implementation BMFContentSizeAspect

- (void) setView:(UIView *)view {
	_view = view;
	if (!_view) return;
}

- (void) setHeightConstraint:(NSLayoutConstraint *)heightConstraint {
	_heightConstraint = heightConstraint;
}

- (void) update {
    UIScrollView *scrollView = (id)self.view;
    [self p_updateConstraintWithValue:scrollView.contentSize.height];
}

#pragma mark Private methods

- (void) p_updateConstraintWithValue:(CGFloat) value {
	BMFAssertReturn(self.heightConstraint);
	self.heightConstraint.constant = value;
	if (self.constraintChanged) self.constraintChanged(self);
}

@end
