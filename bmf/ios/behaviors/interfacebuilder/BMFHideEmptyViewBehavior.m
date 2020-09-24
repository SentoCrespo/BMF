//
//  BMFHideEmptyViewBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/07/14.
//
//

#import "BMFHideEmptyViewBehavior.h"

#import "BMF.h"
#import <ReactiveCocoa/RACEXTScope.h>

@implementation BMFHideEmptyViewBehavior {
	RACDisposable *disposable;
}

- (void) performInit {
	[super performInit];
	
	@weakify(self);
	[[RACObserve(self, view) filter:^BOOL(id value) {
		return value!=nil;
	}] subscribeNext:^(UIView *view) {
		@strongify(self);
		BMFAssertReturn([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]]);
		
		[disposable dispose], disposable = nil;
		disposable = [[view rac_signalForSelector:@selector(reloadData)] subscribeNext:^(id x) {
			[self check];
		}];
	}];
}

- (void) viewWillAppear:(BOOL)animated {
	[self check];
}

- (void) check {
	if (!self.enabled) return;

	BOOL empty = NO;
	UITableView *tableView = [UITableView BMF_cast:self.view];
	if (tableView) {
		empty = [tableView BMF_isEmpty];
	}
	else {
		UICollectionView *collectionView = [UICollectionView BMF_cast:self.view];
		if (collectionView) {
			empty = [collectionView BMF_isEmpty];
		}
	}
	
	_view.hidden = empty;
	self.placeholderView.hidden = !empty;
}

@end
