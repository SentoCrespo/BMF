//
//  BMFBannerViewController.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/06/14.
//
//

#import "BMFBannerViewController.h"

#import "BMFCollectionViewDataSource.h"
#import "BMFBlockTimerViewControllerBehavior.h"
#import "BMFEnumerateDataSourceAspect.h"

#import "BMFUpdateCollectionViewBehavior.h"
#import "BMFItemTapBlockBehavior.h"
#import "BMFScrollDragBlockBehavior.h"

#import "BMFScrollPageChangedBehavior.h"
#import "BMFPagedScrollViewBehavior.h"

#import "BMFBannerItemProtocol.h"

#import "BMF.h"

#import <ReactiveCocoa/RACEXTScope.h>

@interface BMFBannerViewController ()

@property (nonatomic, strong) BMFBlockTimerViewControllerBehavior *timerBehavior;
@property (nonatomic, strong) NSLayoutConstraint *aspectRatioConstraint;

@end

@implementation BMFBannerViewController {
	id orientationObserver;
}

- (void) setSlideAutomatically:(BOOL)slideAutomatically {
	_slideAutomatically = slideAutomatically;
	
	self.timerBehavior.enabled = _slideAutomatically;
}

- (NSArray *) items {
	id<BMFDataReadProtocol> dataStore = self.dataSource.dataStore;
	return [dataStore allItems];
}

- (void) setItems:(NSArray *)items {
	
	id<BMFDataStoreProtocol> dataStore = [NSObject BMF_castObject:self.dataSource.dataStore withProtocol:@protocol(BMFDataStoreProtocol)];
	BMFAssertReturn(dataStore);
	
	[dataStore setItems:items];
	
	self.pageControl.numberOfPages = items.count;
	
	[self updateLayout];
	
	[self.collectionView reloadData];
}

- (void) viewDidLoad {
	self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
	[self.view addSubview:self.collectionView];

	[super viewDidLoad];
	
	BMFAssertReturn(self.cellClass);
	
	self.collectionView.pagingEnabled = YES;
	[BMFAutoLayoutUtils fill:self.view with:self.collectionView margin:0];
	[self.BMF_proxy makeDelegateOf:self.collectionView withSelector:@selector(setDelegate:)];
	
	id<BMFDataStoreProtocol, BMFDataReadProtocol> dataStore = (id)[[BMFBase sharedInstance].factory dataStoreWithParameter:@[] sender:nil];
	BMFAssertReturn([dataStore conformsToProtocol:@protocol(BMFDataStoreProtocol)] && [dataStore conformsToProtocol:@protocol(BMFDataReadProtocol)]);
	self.dataSource = (id)[[BMFBase sharedInstance].factory collectionViewDataSourceWithStore:dataStore cellClassOrNib:self.cellClass sender:self];
	
	self.scrollDirection = BMFBannerViewControllerScrollDirectionHorizontal;
	
	_slideDuration = 5;
	
	BMFEnumerateDataSourceAspect *enumerateAspect = [BMFEnumerateDataSourceAspect new];
	[self.dataSource BMF_addAspect:enumerateAspect];

	@weakify(self);
	self.timerBehavior = [[BMFBlockTimerViewControllerBehavior alloc] initWithActionBlock:^(id sender) {
		[enumerateAspect action:sender completion:^(NSIndexPath *result, NSError *error) {
			@strongify(self);
			if (!error) {
				[self.collectionView selectItemAtIndexPath:result animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
			}
		}];
	} interval:_slideDuration];

	[self addBehavior:self.timerBehavior];
	
	BMFUpdateCollectionViewBehavior *updateCVBehavior = [BMFUpdateCollectionViewBehavior new];
	updateCVBehavior.collectionView = self.collectionView;
	[self addBehavior:updateCVBehavior];
	
	[self addBehavior:[[BMFItemTapBlockBehavior alloc] initWithView:self.collectionView tapBlock:^(id item, NSIndexPath *indexPath) {
		if (self.selectItemBlock) self.selectItemBlock([self.dataSource itemAt:indexPath]);
	}]];
	
	BMFScrollDragBlockBehavior *dragBehavior = [[BMFScrollDragBlockBehavior alloc] initWithView:self.collectionView actionBlock:^(id sender) {
		self.timerBehavior.enabled = NO;
	}];
	
	[self addBehavior:dragBehavior];
	
	BMFPagedScrollViewBehavior *pageChangedBehavior = [[BMFPagedScrollViewBehavior alloc] initWithView:self.collectionView];
	pageChangedBehavior.pageControl = self.pageControl;
	[self addBehavior:pageChangedBehavior];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.timerBehavior.enabled = self.slideAutomatically;
	
	if (self.dataSource.allItems.count>0) [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
	
	[self updateLayout];
}

- (void) viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	[self updateItemsSize];
}

- (void) updateLayout {
	if (self.aspectRatioConstraint) [self.view removeConstraint:self.aspectRatioConstraint];
	
	if ([self.items.firstObject conformsToProtocol:@protocol(BMFBannerItemProtocol)]) {
		CGFloat	aspectRatio = [self.items.firstObject proportion];
		
		self.aspectRatioConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:aspectRatio constant:0];
		[self.view addConstraint:self.aspectRatioConstraint];
	}
	
	[self updateItemsSize];
	
	[self.view bringSubviewToFront:self.pageControl];
	
	UIView *loaderView = [UIView BMF_cast:self.loaderView];
	if (loaderView) [self.view bringSubviewToFront:loaderView];
	
	[UIView animateWithDuration:0.2 animations:^{
		[self.view layoutIfNeeded];
	}];
}

- (void) updateItemsSize {
	UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout BMF_cast:self.collectionView.collectionViewLayout];
	BMFAssertReturn(flowLayout);

	flowLayout.itemSize = self.view.bounds.size;
	
	flowLayout.minimumInteritemSpacing = 0;
	flowLayout.minimumLineSpacing = 0;
	flowLayout.sectionInset = UIEdgeInsetsZero;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	
	UICollectionViewFlowLayout *layout =  [UICollectionViewFlowLayout BMF_cast:self.collectionView.collectionViewLayout];
	BMFAssertReturn(layout);
	layout.itemSize = self.view.bounds.size;
	[self.collectionView reloadData];
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.collectionView selectItemAtIndexPath:[self.collectionView indexPathsForSelectedItems].firstObject animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
	});
}

- (void) setSlideDuration:(NSUInteger)slideDuration {
	_slideDuration = slideDuration;
	
	self.timerBehavior.interval = _slideDuration;
}

- (void) setScrollDirection:(BMFBannerViewControllerScrollDirection)scrollDirection {
	_scrollDirection = scrollDirection;
	
	UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout BMF_cast:self.collectionView.collectionViewLayout];
	BMFAssertReturn(flowLayout);
	
	if (self.scrollDirection==BMFBannerViewControllerScrollDirectionHorizontal)	flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	else flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
}

@end
