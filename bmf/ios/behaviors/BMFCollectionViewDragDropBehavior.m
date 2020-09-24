//
//  BMFCollectionViewDragDropBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/08/14.
//
//

#import "BMFCollectionViewDragDropBehavior.h"

#import "BMF.h"

#import "BMFDataSourceProtocol.h"
#import "BMFDataStoreProtocol.h"
#import "BMFDataReadProtocol.h"

@interface BMFCollectionViewDragDropBehavior()

@property (nonatomic, strong) UICollectionView *startDragCollectionView;
@property (nonatomic, strong) NSIndexPath *startIndexPath;
@property (nonatomic, strong) UIImageView *draggingView;
@property (nonatomic, assign) CGPoint draggingViewStartLocation;

@end

@implementation BMFCollectionViewDragDropBehavior

- (instancetype) initWithCollectionViews:(NSArray *) collectionViews {
	BMFAssertReturnNil(collectionViews.count>1); // Doesn't really make sense to pass only 1
	
	self = [super init];
    if (self) {
        _collectionViews = collectionViews;
		_dragCellScale = 1.4f;
		_minimumPressDuration = 0.05;
		[self addGestureRecognizers];
    }
    return self;
}

- (void) setCollectionViews:(NSArray *)collectionViews {
	[self removeGestureRecognizers];
	
	_collectionViews = collectionViews;
	
	[self addGestureRecognizers];
}

- (void) removeGestureRecognizers {
	for (UICollectionView *collectionView in self.collectionViews) {
		for (UIGestureRecognizer *recognizer in collectionView.gestureRecognizers) {
			if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
				[collectionView removeGestureRecognizer:recognizer];
			}
		}
	}
}

- (void) addGestureRecognizers {
	for (UICollectionView *collectionView in self.collectionViews) {
		BMFAssertReturn([collectionView.dataSource conformsToProtocol:@protocol(BMFDataSourceProtocol)]);
		
		UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
		gestureRecognizer.minimumPressDuration = self.minimumPressDuration;
		[collectionView addGestureRecognizer:gestureRecognizer];
	}
}

- (UICollectionView *) p_collectionViewAtPoint:(CGPoint) aPoint {
	for (UICollectionView *cview in self.collectionViews) {
		CGPoint point = [cview convertPoint:aPoint fromView:self.object.view];
		if ([cview pointInside:point withEvent:nil]) {
			return cview;
		}
	}
	return nil;
}

- (void) longPress:(UIGestureRecognizer *) recognizer {
	UICollectionView *collectionView = [UICollectionView BMF_cast:recognizer.view];
	BMFAssertReturn(collectionView);
	
	CGPoint location = [recognizer locationInView:collectionView];
	
	self.startDragCollectionView = collectionView;
	
	CGPoint locationInScreen = [self.object.view convertPoint:location fromView:recognizer.view];
	
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		
		self.startIndexPath = [collectionView indexPathForItemAtPoint:location];
        if (self.startIndexPath) {
			id<BMFDataSourceProtocol> dataSource = (id<BMFDataSourceProtocol>)collectionView.dataSource;
			
			if (![dataSource.dataStore conformsToProtocol:@protocol(BMFDataStoreProtocol)]) {
				DDLogDebug(@"Start drag from a collection view with a data source that doesn't allow change");
				return;
			}
			
			UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:self.startIndexPath];
		
			UIImage *rasterizedCellImage = [BMFUtils imageWithView:cell];
			
			self.draggingView = [[UIImageView alloc] initWithImage:rasterizedCellImage];
			
			cell.alpha = 0;
			
			[self.object.view addSubview:self.draggingView];
			
			self.draggingView.center = locationInScreen;
			
			self.draggingViewStartLocation = self.draggingView.center;
			[self.object.view bringSubviewToFront:self.draggingView];
			
			[UIView animateWithDuration:.2f animations:^{
				CGAffineTransform transform = CGAffineTransformMakeScale(1.4f, 1.4f);
				self.draggingView.transform = transform;
			}];
		}
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
		
		id<BMFDataSourceProtocol> dataSource = (id)self.startDragCollectionView.dataSource;
		id<BMFDataStoreProtocol,BMFDataReadProtocol> dataStore = (id)dataSource.dataStore;
		id item = [dataStore itemAt:self.startIndexPath];
		
		UICollectionView *dropCollectionView = [self p_collectionViewAtPoint:locationInScreen];
		NSIndexPath *dropIndexPath = [dropCollectionView indexPathForItemAtPoint:[dropCollectionView convertPoint:locationInScreen fromView:self.object.view]];

		if (!self.allowDropBlock || self.allowDropBlock(item,dropCollectionView,dropIndexPath)) {
			if (self.highlightDropCollectionViewBlock) self.highlightDropCollectionViewBlock(dropCollectionView,dropIndexPath);
		}
		
		self.draggingView.center = locationInScreen;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
		
		UICollectionView *dropCollectionView = [self p_collectionViewAtPoint:locationInScreen];
		NSIndexPath *dropIndexPath = [dropCollectionView indexPathForItemAtPoint:[dropCollectionView convertPoint:locationInScreen fromView:self.object.view]];

		UICollectionViewCell *cell = [self.startDragCollectionView cellForItemAtIndexPath:self.startIndexPath];
		cell.alpha = 1.0f;

		if (dropCollectionView!=self.startDragCollectionView) {
			/// Drop to a different view
			id<BMFDataSourceProtocol> dataSource = (id)self.startDragCollectionView.dataSource;
			id<BMFDataSourceProtocol> dropDataSource = (id)dropCollectionView.dataSource;
			
			id<BMFDataStoreProtocol,BMFDataReadProtocol> dataStore = (id)dataSource.dataStore;
			id<BMFDataStoreProtocol,BMFDataReadProtocol> dropDataStore = (id)dropDataSource.dataStore;
			
			id item = [dataStore itemAt:self.startIndexPath];
			
			if (self.moveItemBlock) {
				self.moveItemBlock(item,self.startDragCollectionView,dropCollectionView,dropIndexPath);
			}
			else {
				[dropDataStore startUpdating];
				if (dropIndexPath) [dropDataStore insertItem:item atIndexPath:dropIndexPath];
				else [dropDataStore addItem:item];
				[dropDataStore endUpdating];
				
				[dataStore startUpdating];
				[dataStore removeItem:item];
				[dataStore endUpdating];
			}
		}
		
		[self.draggingView removeFromSuperview], self.draggingView = nil;
		self.draggingViewStartLocation = CGPointZero;
		self.startIndexPath = nil;
	}
}

@end

