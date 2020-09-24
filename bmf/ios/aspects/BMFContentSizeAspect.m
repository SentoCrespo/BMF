//
//  BMFContentSizeAspect.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/5/15.
//
//

#import "BMFContentSizeAspect.h"

#import "BMF.h"

@interface BMFContentSizeAspect()  <UIScrollViewDelegate, UIWebViewDelegate>

@end

@implementation BMFContentSizeAspect

- (void) setView:(UIView *)view {
	_view = view;
	if (!_view) return;
	
	if ([_view isKindOfClass:[UIWebView class]]) {
		UIWebView *webView = (id)self.view;
		webView.delegate = self;
	}
}

- (void) setHeightConstraint:(NSLayoutConstraint *)heightConstraint {
	_heightConstraint = heightConstraint;
}

- (void) update {
	if ([self.view isKindOfClass:[UIWebView class]]) {
		[self p_updateWebViewConstraint:(id)self.view];
	}
	else {
		UIScrollView *scrollView = (id)self.view;
		[self p_updateConstraintWithValue:scrollView.contentSize.height];
	}
}

#pragma mark UIWebViewDelegate

- (void) webViewDidFinishLoad:(UIWebView *)webView {
	if (webView==self.view) {
		[self p_updateWebViewConstraint:webView];
	}
}

#pragma mark Private methods

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
	BMFAssertReturn(self.heightConstraint);
	self.heightConstraint.constant = value;
	if (self.constraintChanged) self.constraintChanged(self);
}


@end
