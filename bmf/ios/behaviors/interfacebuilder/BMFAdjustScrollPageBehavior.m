//
//  BMFAdjustScrollPageBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 22/1/15.
//
//

#import "BMFAdjustScrollPageBehavior.h"

#import "BMF.h"

@interface BMFAdjustScrollPageBehavior()

@end

@implementation BMFAdjustScrollPageBehavior {
	NSInteger horizontalPageIndex;
	NSInteger verticalPageIndex;
}

- (void) viewDidLoad {
	if (!self.enabled) return;
	BMFAssertReturn(self.scrollView.pagingEnabled);
}

- (void) viewWillAppear:(BOOL)animated {
	if (!self.enabled) return;
	BMFAssertReturn(self.scrollView);
	[self restorePageIndexes:self.scrollView.frame.size];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	if (!self.enabled) return;
	BMFAssertReturn(self.scrollView);
	[self savePageIndexes];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	if (!self.enabled) return;
	BMFAssertReturn(self.scrollView);
	[self restorePageIndexes:self.scrollView.frame.size];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	if (!self.enabled) return;
	BMFAssertReturn(self.scrollView);
	
	[self savePageIndexes];
	
	[coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		[self restorePageIndexes:size];
	}];
}

- (void) savePageIndexes {
	horizontalPageIndex = self.scrollView.contentOffset.x/self.scrollView.bounds.size.width;
	verticalPageIndex = self.scrollView.contentOffset.y/self.scrollView.bounds.size.height;
}

- (void) restorePageIndexes:(CGSize) size {
	CGPoint offset = CGPointZero;
	offset.x = size.width*horizontalPageIndex;
	offset.y = size.height*verticalPageIndex;
	[self.scrollView setContentOffset:offset animated:YES];
}


@end
