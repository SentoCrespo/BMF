//
//  UITableView+BMF.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 29/01/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "UITableView+BMF.h"

@implementation UITableView (BMF)

- (void) BMF_deselectAllRowsAnimated:(BOOL)animated {
	for (NSIndexPath *indexPath in self.indexPathsForSelectedRows) {
		[self deselectRowAtIndexPath:indexPath animated:animated];
	}
}

- (void) BMF_automaticCellHeights {
	[self BMF_automaticCellHeights:self.rowHeight];
}

- (void) BMF_automaticCellHeights:(CGFloat) estimatedHeight {
	self.rowHeight = UITableViewAutomaticDimension;
	self.estimatedRowHeight = estimatedHeight;
}

- (void) BMF_showSeparatorsForEmptyCells {
	self.tableFooterView = nil;
}

- (void) BMF_hideSeparatorsForEmptyCells {
	UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
	footer.backgroundColor = [UIColor clearColor];
	self.tableFooterView = footer;
}

- (void) BMF_updateDelegate:(id)delegate {
	self.delegate = nil;
	self.delegate = delegate;
}

- (BOOL) BMF_isEmpty {
	id<UITableViewDataSource> dataSource = self.dataSource;
	if ([dataSource numberOfSectionsInTableView:self]==0) return YES;
	
	for (int i=0;i<[dataSource numberOfSectionsInTableView:self];i++) {
		NSInteger numRows = [dataSource tableView:self numberOfRowsInSection:i];
		if (numRows>0) return NO;
	}
	
	return YES;
}

- (BOOL) BMF_indexPathValid:(NSIndexPath *) indexPath {
	if (self.numberOfSections<=indexPath.section) return NO;
	if ([self numberOfRowsInSection:indexPath.section]<=indexPath.row) return NO;
	
	return YES;
}

- (void) BMF_reloadCellsAtIndexPaths:(NSArray *) indexPaths withAnimation:(UITableViewRowAnimation) updateAnimation {
	BOOL reloadView = NO;
	
	for (NSIndexPath *indexPath in indexPaths) {
		if (![self BMF_indexPathValid:indexPath]) {
			reloadView = YES;
			break;
		}
	}
	
	if (reloadView){
		[self reloadData];
	}
	else {
		[self reloadRowsAtIndexPaths:indexPaths withRowAnimation:updateAnimation];
	}
}

- (void) BMF_enumerateIndexPaths:(BMFObjectActionBlock) actionBlock {
	BMFAssertReturn(actionBlock);
	
	NSInteger numSections = [self numberOfSections];
	for (NSInteger i=0;i<numSections;i++) {
		NSInteger numItems = [self numberOfRowsInSection:i];
		for (NSInteger j=0;j<numItems;j++) {
			actionBlock([NSIndexPath indexPathForItem:j inSection:i]);
		}
	}
}

- (NSIndexPath *) BMF_predecessorOf:(NSIndexPath *) indexPath wrap:(BOOL)wrap {
	NSInteger row = indexPath.BMF_row;
	NSInteger section = indexPath.BMF_section;
	
	row--;
	
	if (row<0) {
		section--;
		if (section<0) {
			if (!wrap) return indexPath;
		}
		section = [self numberOfSections]-1;
		row = MAX([self numberOfRowsInSection:section]-1,0);
	}
	
	return [NSIndexPath BMF_indexPathForRow:row inSection:section];
}

- (NSIndexPath *) BMF_sucessorOf:(NSIndexPath *) indexPath wrap:(BOOL)wrap {
	NSInteger row = indexPath.BMF_row;
	NSInteger section = indexPath.BMF_section;
	
	row++;
	
	if (row>=[self numberOfRowsInSection:section]) {
		row = 0;
		section++;
		if (section>=[self numberOfSections]) {
			if (!wrap) return indexPath;
			section = 0;
		}
	}
	
	return [NSIndexPath BMF_indexPathForRow:row inSection:section];
}

- (void) BMF_scrollToBottom:(BOOL)animated {
	NSInteger numRows = [self numberOfRowsInSection:0];
	if (numRows>0) {
		[self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:numRows-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	}
}

@end
