//
//  BMFScrollOffsetBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/11/14.
//
//

#import "BMFScrollOffsetBehavior.h"

#import "BMF.h"
#import <ReactiveCocoa/RACEXTScope.h>

@interface BMFScrollOffsetBehavior()

@property (nonatomic, assign) CGPoint offset;

@end

@implementation BMFScrollOffsetBehavior

- (void) awakeFromNib {
	@weakify(self);
	RAC(self,offset) =	[RACObserve([BMFBase sharedInstance].keyboardManager, keyboardVisible) map:^id(NSNumber *visible) {
		@strongify(self);
		return [NSValue valueWithCGPoint:self.scrollView.contentOffset];
	}];
}

- (void) setScrollView:(UIScrollView *)scrollView {
	_scrollView = scrollView;
	if (_scrollView) [self.object.BMF_proxy makeDelegateOf:_scrollView withSelector:@selector(setDelegate:)];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	self.offset = self.scrollView.contentOffset;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	self.offset = self.scrollView.contentOffset;
}

- (void) viewWillAppear:(BOOL)animated {
	if (_scrollView) [self.object.BMF_proxy makeDelegateOf:_scrollView withSelector:@selector(setDelegate:)];
}

// Don't do this!!! All the scroll behaviors will stop working
// - (void) viewWillDisappear:(BOOL)animated {
// 	if (_scrollView) [self.object.BMF_proxy removeDelegateOf:_scrollView withSelector:@selector(setDelegate:)];
// }

#pragma mark UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
	if (!self.enabled) return;
	if (scrollView!=self.scrollView) return;
	
	CGFloat incX = fabs(scrollView.contentOffset.x-self.offset.x);
	CGFloat incY = fabs(scrollView.contentOffset.y-self.offset.y);
	if (incX>=self.minimumOffset.x && incY>=self.minimumOffset.y) {
        if ([BMFBase sharedInstance].keyboardManager.showing || [BMFBase sharedInstance].keyboardManager.hiding) return;
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

@end

