//
//  BMFShowScrollPageBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/1/15.
//
//

#import "BMFShowScrollPageBehavior.h"

#import "BMF.h"
#import "UIScrollView+BMF.h"

@implementation BMFShowScrollPageBehavior

- (IBAction) showPage:(id) sender {
	if (!self.enabled) return;
	BMFAssertReturn(self.scrollView);
	
	CGPoint offset = [self.scrollView BMF_offsetForPage:self.pageNumber];
	[UIView animateWithDuration:0.35 animations:^{
		self.scrollView.contentOffset = offset;
	} completion:^(BOOL finished) {
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}];
}

@end
