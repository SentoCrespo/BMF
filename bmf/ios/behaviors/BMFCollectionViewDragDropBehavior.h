//
//  BMFCollectionViewDragDropBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/08/14.
//
//

#import "BMFViewControllerBehavior.h"

#import "BMFTypes.h"

typedef void(^BMFCollectionViewDragDropMoveItemBlock)(id item, UICollectionView *originCollectionView,UICollectionView *destinationCollectionView, NSIndexPath *finalIndexPath);
typedef BOOL(^BMFCollectionViewDragDropAllowDropBlock)(id item, UICollectionView *dropView,NSIndexPath *indexPath);
typedef BOOL(^BMFCollectionViewDragDropHighlightBlock)(UICollectionView *dropView,NSIndexPath *indexPath);

/*
 Models the behavior for drag and drop between collection views. All the collection views data sources must implement the BMFDataSourceProtocol
 */
@interface BMFCollectionViewDragDropBehavior : BMFViewControllerBehavior

@property (nonatomic, strong) NSArray *collectionViews;

/// By default this is done automatically if the data stores implement the BMFDataStoreProtocol. You can implement this to perform a different action or if the data stores don't support the protocol
@property (nonatomic, copy) BMFCollectionViewDragDropMoveItemBlock moveItemBlock;

/// This is called when the user drags something over a collection view without dropping it. It gives the option to highlight the destination collection view to indicate that the item can be dropped there
@property (nonatomic, copy) BMFCollectionViewDragDropHighlightBlock highlightDropCollectionViewBlock;

/// Implement this for a chance to allow or deny permission to drop on a specific collection view
@property (nonatomic, copy) BMFCollectionViewDragDropAllowDropBlock allowDropBlock;

/// Scale to be applied to the dragged cell. 1.4 by default
@property (nonatomic, assign) CGFloat dragCellScale;

/// Press duration to start dragging. 0.05 by default
@property(nonatomic) CFTimeInterval minimumPressDuration;

- (instancetype) initWithCollectionViews:(NSArray *) collectionViews;
- (instancetype) init __attribute__((unavailable("Use initWithCollectionViews: instead")));

@end
