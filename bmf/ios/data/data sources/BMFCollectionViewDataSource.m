//
//  TNCollectionViewDataSource.m
//  DataSources
//
//  Created by José Manuel Sánchez on 21/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFCollectionViewDataSource.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "BMFViewConfigurator.h"

#import "UICollectionView+BMF.h"

@interface BMFCollectionViewDataSource() <UICollectionViewDelegate>

@property (nonatomic, assign) BOOL animatedUpdates;

@end

@implementation BMFCollectionViewDataSource {
	id dataDidChangeObservationToken;
	id dataBatchChangeObservationToken;
}

- (instancetype) initWithDataStore:(id<BMFDataReadProtocol>)dataStore {
	return [self initWithDataStore:dataStore animatedUpdates:NO];
}

- (instancetype) initWithDataStore:(id<BMFDataReadProtocol>)dataStore animatedUpdates:(BOOL)animatedUpdates {
	self = [super initWithDataStore:dataStore];
	if (self) {
		self.animatedUpdates = animatedUpdates;

		[self observeDataChanges];
	}
	return self;
}

- (void) dealloc {
	[self stopObserving];
}

- (void) setDataStore:(id<BMFDataReadProtocol>)dataStore {
	[self stopObserving];
	
	[super setDataStore:dataStore];

	[self observeDataChanges];
	
	[(id)self.view reloadData];
}

- (void) setView:(BMFIXView *)view {
	BMFAssertReturn(!view || [view isKindOfClass:[UICollectionView class]]);
	
	[super setView:view];
	
	UICollectionView *collectionView = [UICollectionView BMF_cast:view];
	
	collectionView.dataSource = self;
	
	[self registerCells];
	[self registerViews];
	
	[collectionView reloadData];
}

//- (void) setCollectionView:(UICollectionView *)collectionView {
//	_view = collectionView;
//	_collectionView.dataSource = self;
//	
//	[self registerCells];
// 	[self registerViews];
//	
//	[_collectionView reloadData];
//}

- (void) setCellRegister:(id<BMFCellRegisterProtocol>)cellRegister {
	_cellRegister = cellRegister;
	[self registerCells];
}

- (void) setSupplementaryViewRegister:(id<BMFViewRegisterProtocol>)supplementaryViewRegister {
	_supplementaryViewRegister = supplementaryViewRegister;
	[self registerViews];
}

- (void) registerCells {
	if (self.view) [self.cellRegister registerCells:self.view];
}

- (void) registerViews {
 	if (self.view) {
		[self.supplementaryViewRegister registerViews:self.view];
	}
}

#pragma mark Observe data changes

- (void) observeDataChanges {
	if (dataDidChangeObservationToken) [[NSNotificationCenter defaultCenter] removeObserver:dataDidChangeObservationToken];
	dataDidChangeObservationToken = [[NSNotificationCenter defaultCenter] addObserverForName:BMFDataDidChangeNotification object:self.dataStore queue:nil usingBlock:^(NSNotification *note) {
//		DDLogDebug(@"data did change collection view reload data");
		[(id)self.view reloadData];
		if (self.dataChangedBlock) self.dataChangedBlock(self.dataStore,nil);
	}];
	
	if (dataBatchChangeObservationToken) [[NSNotificationCenter defaultCenter] removeObserver:dataBatchChangeObservationToken];
	dataBatchChangeObservationToken = [[NSNotificationCenter defaultCenter] addObserverForName:BMFDataBatchChangeNotification object:self.dataStore queue:nil usingBlock:^(NSNotification *note) {
//		DDLogDebug(@"data batch change collection view reload data");
		[(id)self.view reloadData];
		if (self.dataChangedBlock) self.dataChangedBlock(self.dataStore,nil);
	}];
}

- (void) stopObserving {
	if (dataDidChangeObservationToken) [[NSNotificationCenter defaultCenter] removeObserver:dataDidChangeObservationToken];
	if (dataBatchChangeObservationToken) [[NSNotificationCenter defaultCenter] removeObserver:dataBatchChangeObservationToken];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return [self.dataStore numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.dataStore numberOfRowsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	BMFAssertReturnNil(self.view);

	id item = [self.dataStore itemAt:indexPath];
	
	NSString *cellId = [self.cellRegister cellIdentifierForItem:item atIndexPath:indexPath];
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];

	Class<BMFViewConfiguratorProtocol> configurator = [BMFViewConfigurator configuratorForView:cell kind:BMFViewKindCell item:item inView:collectionView];
	
	if (!configurator) {
		DDLogError(@"Error: No configurator found for cell: %@ and item: %@. Did you forget to create or register it?",cell,item);
		return nil;
	}
	
	if (self.willConfigureViewBlock) self.willConfigureViewBlock(configurator,cell);
	
	[configurator configure:cell kind:BMFViewKindCell withItem:item inView:collectionView atIndexPath:indexPath controller:self.controller];
	
	if (self.didConfigureViewBlock) self.didConfigureViewBlock(cell);

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kindString atIndexPath:(NSIndexPath *)indexPath {
	
	NSString *viewId = [self.supplementaryViewRegister viewIdentifierForKind:kindString indexPath:indexPath];
	if (viewId.length==0) return nil;
	
 	UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kindString withReuseIdentifier:viewId forIndexPath:indexPath];
	
	id item = nil;
	if ([self.dataStore indexPathInsideBounds:indexPath]) {
		item = [self.dataStore itemAt:indexPath];
	}
	else {
		item = [self.dataStore titleForSection:indexPath.section kind:kindString];
	}

	Class<BMFViewConfiguratorProtocol> configurator = [BMFViewConfigurator configuratorForView:view kind:kindString item:item inView:collectionView];

	if (!configurator) DDLogWarn(@"Warning: no configurator found for supplementary view: %@",view);
	
	if (self.willConfigureViewBlock) self.willConfigureViewBlock(configurator,view);
	
	[configurator configure:view kind:kindString withItem:item inView:collectionView atIndexPath:indexPath controller:self.controller];

	if (self.didConfigureViewBlock) self.didConfigureViewBlock(view);

	return view;
}

@end
