//
//  BMFTableViewPinToHeaderBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/06/14.
//
//

#import "BMFTableViewPinToHeaderBehavior.h"

#import "BMF.h"

@implementation BMFTableViewPinToHeaderBehavior

- (void) viewDidLoad {
	if (!self.enabled) return;
	BMFAssertReturn(self.tableView);
	[self.object.BMF_proxy makeDelegateOf:self.tableView withSelector:@selector(setDelegate:)];
}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	if (!self.enabled) return;

	BMFAssertReturn(self.tableView.tableHeaderView);
	
	CGFloat computedTargetOffset = scrollView.contentOffset.y+self.tableView.contentInset.top;

	CGFloat time = 0.2;
	
	[UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		
		if (computedTargetOffset<(self.tableView.tableHeaderView.bounds.size.height/3.0)) {
			*targetContentOffset = CGPointMake(targetContentOffset->x, 0);
			self.tableView.contentInset = UIEdgeInsetsZero;
		}
		else {
			if (computedTargetOffset<(self.tableView.tableHeaderView.bounds.size.height)) {
				*targetContentOffset = CGPointMake(targetContentOffset->x, self.tableView.tableHeaderView.bounds.size.height);
			}
			
			self.tableView.contentInset = UIEdgeInsetsMake(-self.tableView.tableHeaderView.bounds.size.height, 0, 0, 0);
		}
	} completion:nil];
}

@end
