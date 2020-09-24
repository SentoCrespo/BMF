//
//  BMFItemTapBehavior.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFItemTapBehavior.h"

#import "BMFDataSourceProtocol.h"
#import "BMFDataReadProtocol.h"

#import "BMF.h"

@interface BMFItemTapBehavior()

@property (nonatomic) NSArray *selectedIndexPaths;

@end

@implementation BMFItemTapBehavior

- (instancetype)init {
	self = [super init];
	if (self) {
		self.deselectAutomatically = YES;
		_selectedIndexPaths = nil;
    }
	return self;
}

- (id) itemInDataSource:(id<BMFDataSourceProtocol>) dataSource atIndexPath:(NSIndexPath *) indexPath containerView:(UIView *) containerView {
	BMFAssertReturnNil([dataSource conformsToProtocol:@protocol(BMFDataSourceProtocol)]);
	
	id<BMFDataReadProtocol> dataStore = dataSource.dataStore;
	return [dataStore itemAt:indexPath];
}

- (void) setView:(UIView *)view {
	if (_view==view) return;
	if (_view) [self.object.BMF_proxy removeDelegateOf:_view withSelector:@selector(setDelegate:)];
	_view = view;
	if (_view) [self.object.BMF_proxy makeDelegateOf:_view withSelector:@selector(setDelegate:)];
}

- (void) setObject:(UIViewController<BMFBehaviorsViewControllerProtocol> *)object {
	[super setObject:object];
	
	if (object && _view) {
		[self.object.BMF_proxy makeDelegateOf:_view withSelector:@selector(setDelegate:)];
	}
}

#pragma mark View Controller events

- (void) viewWillAppear:(BOOL)animated {
	if (!self.enabled) return;
	BMFAssertReturn(self.view);
	
	if (!self.selectedIndexPaths) self.selectedIndexPaths = [self p_currentSelectedIndexPaths];
	else {
		[self p_selectIndexPaths:self.selectedIndexPaths animated:NO];
	}
	
	[self p_deselectIndexPaths:self.selectedIndexPaths animated:animated];
}

- (NSArray *) p_currentSelectedIndexPaths {
	UITableView *tableView = [UITableView BMF_cast:self.view];
	if (tableView) {
		return [tableView indexPathsForSelectedRows];
	}
	else {
		UICollectionView *collectionView = [UICollectionView BMF_cast:self.view];
		if (collectionView) {
			return [collectionView indexPathsForSelectedItems];
		}
		else {
			BMFThrowException(@"Unknown view type for item tap behavior");
		}
	}
	
	return nil;
}

- (void) p_selectIndexPaths:(NSArray *) indexPaths animated:(BOOL) animated {
	if (indexPaths.count==0) return;
	
	UITableView *tableView = [UITableView BMF_cast:self.view];
	if (tableView) {
		for (NSIndexPath *indexPath in indexPaths) {
			return [tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:UITableViewScrollPositionNone];
		}
	}
	else {
		UICollectionView *collectionView = [UICollectionView BMF_cast:self.view];
		if (collectionView) {
			for (NSIndexPath *indexPath in indexPaths) {
				[collectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:UICollectionViewScrollPositionNone];
			}
		}
		else {
			BMFThrowException(@"Unknown view type for item tap behavior");
		}
	}
}

- (void) p_deselectIndexPaths:(NSArray *) indexPaths animated:(BOOL) animated {
	UITableView *tableView = [UITableView BMF_cast:self.view];
	if (tableView) {
		for (NSIndexPath *indexPath in indexPaths) {
			return [tableView deselectRowAtIndexPath:indexPath animated:animated];
		}
	}
	else {
		UICollectionView *collectionView = [UICollectionView BMF_cast:self.view];
		if (collectionView) {
			for (NSIndexPath *indexPath in indexPaths) {
				[collectionView deselectItemAtIndexPath:indexPath animated:animated];
			}
		}
		else {
			BMFThrowException(@"Unknown view type for item tap behavior");
		}
	}
}

- (void) viewDidAppear:(BOOL)animated {
	if (!self.enabled) return;
	
	self.selectedIndexPaths = nil;
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.enabled) return;
	BMFAssertReturn(self.view);
	if (tableView!=self.view) return;
	[self tapInDataSource:(id<BMFDataSourceProtocol>)tableView.dataSource indexPath:indexPath containerView:tableView];
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	if (!self.enabled) return;
	BMFAssertReturn(self.view);
	if (tableView!=self.view) return;
	id item = [self itemInDataSource:(id<BMFDataSourceProtocol>)tableView.dataSource atIndexPath:indexPath containerView:tableView];

	[self accessoryItemTapped:item atIndexPath:indexPath containerView:tableView];
}

#pragma mark UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.enabled) return;
	BMFAssertReturn(self.view);
	if (collectionView!=self.view) return;
	[self tapInDataSource:(id<BMFDataSourceProtocol>)collectionView.dataSource indexPath:indexPath containerView:collectionView];
}

#pragma mark Item tap

- (void) tapInDataSource:(id<BMFDataSourceProtocol>) dataSource indexPath:(NSIndexPath *)indexPath containerView:(UIView *) containerView {
	if (![dataSource indexPathInsideBounds:indexPath]) return;
	
	id item = [self itemInDataSource:dataSource atIndexPath:indexPath containerView:containerView];
	[self itemTapped:item atIndexPath:indexPath containerView:containerView];
}

- (void) itemTapped:(id) item atIndexPath:(NSIndexPath *)indexPath containerView:(UIView *)containerView {
	BMFAbstractMethod();
}

- (void) accessoryItemTapped:(id) item atIndexPath:(NSIndexPath *) indexPath containerView:(UIView *) containerView {}

@end
