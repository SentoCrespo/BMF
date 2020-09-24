//
//  TNTableDataSource.m
//  DataSources
//
//  Created by José Manuel Sánchez on 21/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFTableViewDataSource.h"

#import "BMFViewConfigurator.h"
#import "BMF.h"

#import "NSObject+BMF.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACExtScope.h>

@interface BMFTableViewDataSource()

@property (nonatomic, assign) BOOL animatedUpdates;

@property (nonatomic, strong) NSMutableArray *observationTokens;

@end

@implementation BMFTableViewDataSource

- (instancetype) initWithDataStore:(id<BMFDataReadProtocol>) dataStore {
	return [self initWithDataStore:dataStore animatedUpdates:NO];
}

- (instancetype) initWithDataStore:(id<BMFDataReadProtocol>)dataStore animatedUpdates:(BOOL)animatedUpdates {
    self = [super initWithDataStore:dataStore];
    if (self) {
		self.animatedUpdates = animatedUpdates;
		
		self.observationTokens = [NSMutableArray array];
		
		[self observeDataChanges];
		
		@weakify(self);
		[RACObserve(self, viewRegister) subscribeNext:^(id x) {
			@strongify(self);
			[self registerViews];
		}];
		
		[RACObserve(self, cellRegister) subscribeNext:^(id x) {
			@strongify(self);
			[self registerCells];
		}];

    }
    return self;
}

- (void) observeDataChanges {
	[self stopObserving];
	
	BMFAssertReturn(self.observationTokens);
	BMFAssertReturn(self.observationTokens.count==0);

	if (self.animatedUpdates) {
		[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataWillChangeNotification object:self.dataStore] subscribeNext:^(NSNotification *note) {
			UITableView *tableView = (id)self.view;
			
			DDLogDebug(@"Data will change");
			
			[tableView beginUpdates];
		}]];
		
		
		[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataSectionInsertedNotification object:self.dataStore] subscribeNext:^(NSNotification *note) {
			UITableView *tableView = (id)self.view;
			
			NSDictionary *dic = [NSDictionary BMF_cast:note.userInfo];
			NSNumber *index = dic[@"index"];
			if (index) [tableView insertSections:[NSIndexSet indexSetWithIndex:index.integerValue] withRowAnimation:UITableViewRowAnimationAutomatic];
		}]];
		
		[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataSectionDeletedNotification object:self.dataStore] subscribeNext:^(NSNotification *note) {
			UITableView *tableView = (id)self.view;
			
			NSDictionary *dic = [NSDictionary BMF_cast:note.userInfo];
			NSNumber *index = dic[@"index"];
			if (index) [tableView deleteSections:[NSIndexSet indexSetWithIndex:index.integerValue] withRowAnimation:UITableViewRowAnimationAutomatic];
		}]];
		
		[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataInsertedNotification object:self.dataStore] subscribeNext:^(NSNotification *note) {
			UITableView *tableView = (id)self.view;
			
			DDLogDebug(@"Inserted row: %@",note);
			
			NSDictionary *dic = [NSDictionary BMF_cast:note.userInfo];
			NSIndexPath *indexPath = dic[@"indexPath"];
			if (indexPath) [tableView insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
		}]];
		
		[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataDeletedNotification object:self.dataStore] subscribeNext:^(NSNotification *note) {
			UITableView *tableView = (id)self.view;
			
			NSDictionary *dic = [NSDictionary BMF_cast:note.userInfo];
			NSIndexPath *indexPath = dic[@"indexPath"];
			if (indexPath) [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
		}]];
		
		[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataUpdatedNotification object:self.dataStore] subscribeNext:^(NSNotification *note) {
			UITableView *tableView = (id)self.view;
			
			NSDictionary *dic = [NSDictionary BMF_cast:note.userInfo];
			NSIndexPath *indexPath = dic[@"indexPath"];
			if (indexPath) [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
		}]];
		
		[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataDidChangeNotification object:self.dataStore] subscribeNext:^(NSNotification *note) {
			UITableView *tableView = (id)self.view;
			
			DDLogDebug(@"Data did change");
			
			@try {
				[tableView endUpdates];
			}
			@catch (NSException *exception) {
				DDLogError(@"Exception updating table: %@",exception);
				[tableView reloadData];
			}
			
			[self notifyDataChanged];
		}]];
	}

	[self.observationTokens addObject:[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataBatchChangeNotification object:self.dataStore] throttle:0.5] subscribeNext:^(id x) {
		UITableView *tableView = (id)self.view;
		[tableView reloadData];
		[self notifyDataChanged];
	}]];
}

- (void) dealloc {
	[self stopObserving];
}

- (void) stopObserving {
	
	for (id token in self.observationTokens) {
		[token dispose];
	}
	
	[self.observationTokens removeAllObjects];
}

#pragma mark Accessors

- (void) setDataStore:(id<BMFDataReadProtocol>)dataStore {
	[self stopObserving];
	
	[super setDataStore:dataStore];
	
	[self observeDataChanges];
	
	UITableView *tableView = (id)self.view;
	[tableView reloadData];
}

- (void) setView:(BMFIXView *)view {
	BMFAssertReturn(!view || [view isKindOfClass:[UITableView class]]);
	
	[super setView:view];
	
	UITableView *tableView = (id)view;
	
	tableView.dataSource = self;
	
	[self registerCells];
	[self registerViews];

	[tableView reloadData];
}

//- (void) setTableView:(UITableView *)tableView {
// 	_tableView = tableView;
//	
//	_tableView.dataSource = self;
// 	
//	[self registerCells];
//	[self registerViews];
//	
//	[_tableView reloadData];
//}

- (void) setAllowEditing:(BOOL)allowEditing {
	BMFAssertReturn(!allowEditing || [self.dataStore conformsToProtocol:@protocol(BMFDataStoreProtocol)]);
	
	_allowEditing = allowEditing;
}

- (void) registerCells {
	if (self.cellRegister) [self.cellRegister registerCells:self.view];
}

- (void) registerViews {
 	if (self.viewRegister) [self.viewRegister registerViews:self.view];
}

#pragma mark UITableViewDataSource

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self titleForSection:section kind:BMFViewKindSectionHeader];
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return [self titleForSection:section kind:BMFViewKindSectionFooter];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.dataStore numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.dataStore numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	BMFAssertReturnNil(self.view);
	
	UITableView *tableView = (id)self.view;
	
	NSString *cellId = [self.cellRegister cellIdentifierForItem:[self.dataStore itemAt:indexPath.section row:indexPath.row] atIndexPath:indexPath];
	
	
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    id item = [self.dataStore itemAt:indexPath.section row:indexPath.row];
	
	
	Class<BMFViewConfiguratorProtocol> configurator = [BMFViewConfigurator configuratorForView:cell kind:BMFViewKindCell item:item inView:tableView];
	
	if (!configurator) {
		DDLogError(@"Error: No configurator found for cell: %@ and item: %@. Did you forget to create or register it?",cell,item);
	}
	
	if (self.willConfigureViewBlock) self.willConfigureViewBlock(configurator,cell);
	
	if (self.selectionStyle!=UITableViewCellSelectionStyleDefault) {
		cell.selectionStyle = self.selectionStyle;
	}
	
	[configurator configure:cell kind:BMFViewKindCell withItem:item inView:tableView atIndexPath:indexPath controller:self.controller];
	
	if (self.didConfigureViewBlock) self.didConfigureViewBlock(cell);

    return cell;
}

#pragma mark UITableViewDelegate

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return self.allowEditing;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.allowEditing) return;
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		id<BMFDataStoreProtocol,BMFDataReadProtocol> store = [(id)self.dataStore BMF_castWithProtocol:@protocol(BMFDataStoreProtocol)];
		id item = [store itemAt:indexPath];
		if (item) {
			[store startUpdating];
			[store removeItem:item];
			[store endUpdating];
			
			if (self.itemDeletedBlock) self.itemDeletedBlock(item, indexPath);
		}
	}
}


//- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	id item = [self.dataStore itemAt:indexPath.section row:indexPath.row];
//	
//	NSString *cellId = [self.cellRegister cellIdentifierForItem:[self.dataStore itemAt:indexPath.section row:indexPath.row] atIndexPath:indexPath];
//	
//	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//	
//	id<BMFViewConfiguratorProtocol> configurator = [BMFViewConfigurator configuratorForView:cell kind:BMFViewKindCell item:item inView:tableView];
//	
//	if ([configurator respondsToSelector:@selector(estimatedHeightOf:kind:withItem:inView:atIndexPath:)]) {
//		return [configurator estimatedHeightOf:cell kind:BMFViewKindCell withItem:item inView:tableView atIndexPath:indexPath];
//	}
//	
//	return tableView.estimatedRowHeight;
//}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (BMF_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && tableView.rowHeight==UITableViewAutomaticDimension) {
        return UITableViewAutomaticDimension;
    }
	
	id item = [self.dataStore itemAt:indexPath.section row:indexPath.row];
	
	NSString *cellId = [self.cellRegister cellIdentifierForItem:[self.dataStore itemAt:indexPath.section row:indexPath.row] atIndexPath:indexPath];

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	id<BMFViewConfiguratorProtocol> configurator = [BMFViewConfigurator configuratorForView:cell kind:BMFViewKindCell item:item inView:tableView];
	
	if ([configurator respondsToSelector:@selector(heightOf:kind:withItem:inView:atIndexPath:)]) {
		return [configurator heightOf:cell kind:BMFViewKindCell withItem:item inView:tableView atIndexPath:indexPath];
	}
	
	return tableView.rowHeight;
}

- (UIView *) tableView:(UITableView *)tableView viewWithKind:(NSString *)kind atIndexPath:(NSIndexPath *) indexPath {
	id item = [self.dataStore itemAt:indexPath];
	
	NSString *viewId = [self.viewRegister viewIdentifierForKind:kind indexPath:indexPath];
	
	id view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
	
	Class<BMFViewConfiguratorProtocol> configurator = [BMFViewConfigurator configuratorForView:view kind:kind item:item inView:tableView];
	
	[configurator configure:view kind:kind withItem:item inView:tableView atIndexPath:indexPath controller:self.controller];
	
	return view;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];

	return [self tableView:tableView viewWithKind:BMFViewKindSectionHeader atIndexPath:indexPath];
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
	
	return [self tableView:tableView viewWithKind:BMFViewKindSectionFooter atIndexPath:indexPath];
}

- (CGFloat) tableView:(UITableView *)tableView heightForViewKind:(NSString *)kind atIndexPath:(NSIndexPath *) indexPath {
	id item = nil;
	if (self.isEmpty || [self numberOfRowsInSection:indexPath.section]==0) {
		return 0;
	}

	item = [self.dataStore itemAt:indexPath];
	NSString *viewId = [self.viewRegister viewIdentifierForKind:kind indexPath:indexPath];
	
	id view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
	
	id<BMFViewConfiguratorProtocol> configurator = [BMFViewConfigurator configuratorForView:view kind:kind item:item inView:tableView];
	
	if ([configurator respondsToSelector:@selector(heightOf:kind:withItem:inView:atIndexPath:)]) {
		return [configurator heightOf:view kind:kind withItem:item inView:tableView atIndexPath:indexPath];
	}
	
	return UITableViewAutomaticDimension;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (BMF_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && tableView.sectionHeaderHeight==UITableViewAutomaticDimension) {
        return tableView.estimatedSectionHeaderHeight;
    }
    
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
	
	return [self tableView:tableView heightForViewKind:BMFViewKindSectionHeader atIndexPath:indexPath];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (BMF_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && tableView.sectionFooterHeight==UITableViewAutomaticDimension) {
        return tableView.estimatedSectionFooterHeight;
    }
    
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
	
	return [self tableView:tableView heightForViewKind:BMFViewKindSectionFooter atIndexPath:indexPath];
}


@end
