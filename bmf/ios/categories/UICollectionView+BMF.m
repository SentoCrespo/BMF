//
//  UICollectionView+BMF.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 03/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "UICollectionView+BMF.h"

@implementation UICollectionView (BMF)

- (void) BMF_updateDelegate:(id)delegate {
	self.delegate = nil;
	self.delegate = delegate;
}

- (BOOL) BMF_isEmpty {
	id<UICollectionViewDataSource> dataSource = self.dataSource;
	if ([dataSource numberOfSectionsInCollectionView:self]==0) return YES;
	
	for (int i=0;i<[dataSource numberOfSectionsInCollectionView:self];i++) {
		NSInteger numRows = [dataSource collectionView:self numberOfItemsInSection:i];
		if (numRows>0) return NO;
	}
	
	return YES;
}

- (BOOL) BMF_indexPathValid:(NSIndexPath *) indexPath {
	if (self.numberOfSections<=indexPath.section) return NO;
	if ([self numberOfItemsInSection:indexPath.section]<=indexPath.row) return NO;
	
	return YES;
}

- (void) BMF_reloadCellsAtIndexPaths:(NSArray *) indexPaths {
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
		[self reloadItemsAtIndexPaths:indexPaths];
	}
}

- (void) BMF_enumerateIndexPaths:(BMFObjectActionBlock) actionBlock {
	BMFAssertReturn(actionBlock);
	
	NSInteger numSections = [self numberOfSections];
	for (NSInteger i=0;i<numSections;i++) {
		NSInteger numItems = [self numberOfItemsInSection:i];
		for (NSInteger j=0;j<numItems;j++) {
			actionBlock([NSIndexPath indexPathForItem:j inSection:i]);
		}
	}
}

- (void) BMF_invalidateLayout {
	[self performBatchUpdates:nil completion:nil];
}

@end
