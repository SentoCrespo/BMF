//
//  BMFDeselectTableCellsOnAppearBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 17/2/15.
//
//

#import "BMFDeselectCellsBehavior.h"

#import "BMF.h"

@interface BMFDeselectCellsBehavior() <UITableViewDelegate, UICollectionViewDelegate>

@end

@implementation BMFDeselectCellsBehavior

- (void) setView:(UIView *)view {
	BMFAssertReturn([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]]);
	
	if (_view) [self.object.BMF_proxy removeDelegateOf:_view withSelector:@selector(setDelegate:)];
	if (view) [self.object.BMF_proxy makeDelegateOf:view withSelector:@selector(setDelegate:)];
	
	_view = view;
}

- (IBAction) deselect:(id)sender {
	if (!self.enabled) return;
	
	UITableView *tableView = [UITableView BMF_cast:self.view];
	if (tableView) {
		for (NSIndexPath *indexPath in tableView.indexPathsForSelectedRows) {
			[tableView deselectRowAtIndexPath:indexPath animated:self.animated];
		}
	}
	else {
		UICollectionView *collectionView = [UICollectionView BMF_cast:self.view];
		if (collectionView) {
			for (NSIndexPath *indexPath in collectionView.indexPathsForSelectedItems) {
				[collectionView deselectItemAtIndexPath:indexPath animated:self.animated];
			}			
		}
		else {
			BMFThrowException(@"Unknown view type for deselect cells behavior");
		}
	}
}

@end
