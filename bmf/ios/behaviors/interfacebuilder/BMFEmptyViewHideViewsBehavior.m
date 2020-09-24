//
//  BMFEmptyViewHideViewsBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/2/15.
//
//

#import "BMFEmptyViewHideViewsBehavior.h"

#import "BMF.h"
#import <ReactiveCocoa/RACEXTScope.h>

@implementation BMFEmptyViewHideViewsBehavior {
	RACDisposable *disposable;
}

- (void) performInit {
	[super performInit];
	
	@weakify(self);
	[[RACObserve(self, sourceView) filter:^BOOL(id value) {
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

- (void) awakeFromNib {
	[super awakeFromNib];
	
	self.animationDuration = 0.5;
}

- (void) viewWillAppear:(BOOL)animated {
	[self check];
}

- (void) check {
	if (!self.enabled) return;
	
	BOOL empty = NO;
	UITableView *tableView = [UITableView BMF_cast:self.sourceView];
	if (tableView) {
		empty = [tableView BMF_isEmpty];
	}
	else {
		UICollectionView *collectionView = [UICollectionView BMF_cast:self.sourceView];
		if (collectionView) {
			empty = [collectionView BMF_isEmpty];
		}
	}
	
	if (self.animated) {
		CGFloat alpha = 0;
		if (!empty) alpha = 1;
		[UIView animateWithDuration:self.animationDuration animations:^{
			for (UIView *view in self.views) {
				view.alpha = alpha;
			}
		}];
	}
	else {
		for (UIView *view in self.views) {
			view.hidden = empty;
		}
	}
}

@end
