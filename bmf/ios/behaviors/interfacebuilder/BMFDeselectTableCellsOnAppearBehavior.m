//
//  BMFDeselectTableCellsOnAppearBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 5/3/15.
//
//

#import "BMFDeselectTableCellsOnAppearBehavior.h"

#import "BMF.h"

@interface BMFDeselectTableCellsOnAppearBehavior()

@property (nonatomic) NSArray *selectedIndexPaths;

@end

@implementation BMFDeselectTableCellsOnAppearBehavior

- (void) viewWillAppear:(BOOL)animated {
	if (!self.enabled) return;
	
	if (!self.selectedIndexPaths) self.selectedIndexPaths = self.tableView.indexPathsForSelectedRows;
	else {
		for (NSIndexPath *indexPath in self.selectedIndexPaths) {
			[self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
		}
	}
	
	for (NSIndexPath *indexPath in self.selectedIndexPaths) {
		[self.tableView deselectRowAtIndexPath:indexPath animated:animated];
	}
}

- (void) viewDidAppear:(BOOL)animated {
	if (!self.enabled) return;
	
	self.selectedIndexPaths = nil;
}

@end
