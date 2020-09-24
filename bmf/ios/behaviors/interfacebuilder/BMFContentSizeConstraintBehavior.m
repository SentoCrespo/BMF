//
//  BMFContentSizeConstraintBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/3/15.
//
//

#import "BMFContentSizeConstraintBehavior.h"

#import "BMF.h"

@interface BMFContentSizeConstraintBehavior() <UIScrollViewDelegate, UIWebViewDelegate>

@end

@implementation BMFContentSizeConstraintBehavior

- (void) viewDidLoad {
	if (!self.enabled) return;
	BMFAssertReturn(self.view && self.constraint);
	
	UIScrollView *scrollView = (id)self.view;
	
	if ([self.view isKindOfClass:[UIWebView class]]) {
		UIWebView *webView = (id)self.view;
		scrollView = webView.scrollView;
		[self.object.BMF_proxy makeDelegateOf:webView withSelector:@selector(setDelegate:)];
	}
		
	BMFAssertReturn(scrollView);
	
	@weakify(self);
	[RACObserve(scrollView, contentSize) subscribeNext:^(id x) {
		@strongify(self);
		scrollView.scrollEnabled = NO;
		[self p_updateConstraintWithValue:scrollView.contentSize.height];
	}];
}

- (void) p_updateWebViewConstraint:(UIWebView *)webView {
	[UIView performWithoutAnimation:^{
		[self p_updateConstraintWithValue:1];
		[self.view layoutIfNeeded];		
	}];
	CGFloat height = webView.scrollView.contentSize.height;
	[self p_updateConstraintWithValue:height];
	webView.scrollView.scrollEnabled = NO;
}

- (void) p_updateConstraintWithValue:(CGFloat) value {
	if (!self.enabled) return;
	BMFAssertReturn(self.constraint);
	self.constraint.constant = value;
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	if ([self.view isKindOfClass:[UIWebView class]]) {
		[self p_updateWebViewConstraint:(id)self.view];
	}
}

#pragma mark UIWebViewDelegate

- (void) webViewDidFinishLoad:(UIWebView *)webView {
	if (!self.enabled) return;
	if (webView==self.view) {
		[self p_updateWebViewConstraint:webView];
	}
}

@end
