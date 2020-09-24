//
//  BMFContentSizeConstraintBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/3/15.
//
//

#import "BMFContentSizeConstraintBehavior.h"

#import "BMF.h"

@interface BMFContentSizeConstraintBehavior() <UIScrollViewDelegate>

@end

@implementation BMFContentSizeConstraintBehavior

- (void) viewDidLoad {
	if (!self.enabled) return;
	BMFAssertReturn(self.view && self.constraint);
	
	UIScrollView *scrollView = (id)self.view;
		
	BMFAssertReturn(scrollView);
	
	@weakify(self);
	[RACObserve(scrollView, contentSize) subscribeNext:^(id x) {
		@strongify(self);
		scrollView.scrollEnabled = NO;
		[self p_updateConstraintWithValue:scrollView.contentSize.height];
	}];
}

- (void) p_updateConstraintWithValue:(CGFloat) value {
	if (!self.enabled) return;
	BMFAssertReturn(self.constraint);
	self.constraint.constant = value;
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

}

@end
