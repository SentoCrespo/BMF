//
//  BMFDisplayItemBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/1/15.
//
//

#import "BMFDisplayItemBehavior.h"

#import "BMFDataSourceProtocol.h"
#import "BMFDataReadProtocol.h"

#import "BMF.h"

@implementation BMFDisplayItemBehavior

- (id) itemInDataSource:(id<BMFDataSourceProtocol>) dataSource atIndexPath:(NSIndexPath *) indexPath containerView:(UIView *) containerView {
	BMFAssertReturnNil([dataSource conformsToProtocol:@protocol(BMFDataSourceProtocol)]);
	
	id<BMFDataReadProtocol> dataStore = dataSource.dataStore;
	return [dataStore itemAt:indexPath];
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	id item = [self itemInDataSource:(id<BMFDataSourceProtocol>)tableView.dataSource atIndexPath:indexPath containerView:tableView];
	[self willDisplay:item atIndexPath:indexPath view:cell containerView:tableView];
}

- (void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	id item = [self itemInDataSource:(id<BMFDataSourceProtocol>)tableView.dataSource atIndexPath:indexPath containerView:tableView];
	[self didDisplay:item atIndexPath:indexPath view:cell containerView:tableView];
}

#pragma mark UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	id item = [self itemInDataSource:(id<BMFDataSourceProtocol>)collectionView.dataSource atIndexPath:indexPath containerView:collectionView];
	[self willDisplay:item atIndexPath:indexPath view:cell containerView:collectionView];
}

- (void) collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	id item = [self itemInDataSource:(id<BMFDataSourceProtocol>)collectionView.dataSource atIndexPath:indexPath containerView:collectionView];
	[self didDisplay:item atIndexPath:indexPath view:cell containerView:collectionView];
}

#pragma mark Template methods

- (void) willDisplay:(id) item atIndexPath:(NSIndexPath *) indexPath view:(UIView *)view containerView:(UIView *) containerView {
	BMFAbstractMethod();
}

- (void) didDisplay:(id) item atIndexPath:(NSIndexPath *) indexPath view:(UIView *)view containerView:(UIView *) containerView {
	BMFAbstractMethod();
}


@end
