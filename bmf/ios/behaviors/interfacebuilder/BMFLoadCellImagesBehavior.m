//
//  BMFLoadCellImagesBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 5/3/15.
//
//

#import "BMFLoadCellImagesBehavior.h"

#import "BMF.h"
#import "BMFViewController.h"

@interface BMFLoadCellImagesBehavior () <UITableViewDelegate, UICollectionViewDelegate>

@property (nonatomic) NSMapTable *itemTaskTable;

@end

@implementation BMFLoadCellImagesBehavior

- (instancetype)init
{
	self = [super init];
	if (self) {
		_itemTaskTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
	}
	return self;
}

- (void) setView:(UIView *)view {
	BMFAssertReturn([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]]);
	_view = view;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.enabled) return;
	if (tableView!=self.view) return;
	
	[self p_didDisplayItem:[self p_itemAtIndexPath:indexPath]];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.enabled) return;
	if (collectionView!=self.view) return;
	
	[self p_didDisplayItem:[self p_itemAtIndexPath:indexPath]];
}

- (id) p_itemAtIndexPath:(NSIndexPath *)indexPath {
	id<BMFDataReadProtocol> dataSource = [NSObject BMF_castObject:[(id)self.view dataSource] withProtocol:@protocol(BMFDataReadProtocol)];
	BMFAssertReturnNil(dataSource);

	return [dataSource itemAt:indexPath];
}

- (NSIndexPath *) p_indexPathForItem:(id) item {
	id<BMFDataReadProtocol> dataSource = [NSObject BMF_castObject:[(id)self.view dataSource] withProtocol:@protocol(BMFDataReadProtocol)];
	BMFAssertReturnNil(dataSource);

	return [dataSource indexOfItem:item];
}

- (void) p_didDisplayItem:(id)item {
	BMFAssertReturn(self.imagePropertyName.length>0);
	BMFAssertReturn(self.urlPropertyName.length>0);
	if ([item valueForKey:self.imagePropertyName]!=nil) return;
	
	id<BMFTaskProtocol> loadTask = [self p_imageLoadTaskForItem:item];
	if (!loadTask) return;

	if ([self.itemTaskTable objectForKey:item]) return;
	[self.itemTaskTable setObject:loadTask forKey:item];
	[loadTask run:^(id result, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.itemTaskTable removeObjectForKey:item];
			if (result) {
				[item setValue:result forKey:self.imagePropertyName];
				[self p_reloadCellForItem:item];
			}
			else {
				BMFLogError(@"Image load error: %@",error);
			}
		});
	}];
}

- (id<BMFTaskProtocol>) p_imageLoadTaskForItem:(id) item {
	if (self.createLoadTaskBlock) {
		return self.createLoadTaskBlock(item);
	}
	
	NSURL *url = [item valueForKey:self.urlPropertyName];
	if (!url) return nil;
	
	return [[BMFBase sharedInstance].factory imageLoadTask:url.absoluteString parameters:nil sender:self];
}

- (void) p_reloadCellForItem:(id)item {
	NSIndexPath *indexPath = [self p_indexPathForItem:item];
	if (indexPath) {
		UITableView *tableView = [UITableView BMF_cast:self.view];
		if (tableView) {
			[tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
		else {
			UICollectionView *collectionView = [UICollectionView BMF_cast:self.view];
			if (collectionView) {
				[collectionView reloadItemsAtIndexPaths:@[ indexPath ]];
			}
		}
	}
}

@end
