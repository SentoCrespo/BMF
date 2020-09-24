//
//  BMFDataSource.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 04/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFDataSource.h"

#import "BMF.h"

@implementation BMFDataSource

- (instancetype) initWithDataStore:(id<BMFDataReadProtocol>) dataStore {
	BMFAssertReturnNil(dataStore);
	BMFAssertReturnNil(dataStore.progress);
	
    self = [super init];
    if (self) {
        _dataStore = dataStore;
		_progress = [[BMFProgress alloc] init];
		[_progress addChild:_dataStore.progress];
    }
    return self;
}

//- (id)init {
//	[NSException raise:@"Data store is needed. Use initWithDataStore: instead" format:nil];
//	return nil;
//}

- (void) setDataStore:(id<BMFDataReadProtocol>)dataStore {
	BMFAssertReturn(dataStore);
	
	[self.progress removeChild:_dataStore.progress];
	_dataStore = dataStore;
	[self.progress addChild:_dataStore.progress];
}

- (void) notifyValueChanged:(id)sender {
	if (self.applyValueBlock) self.applyValueBlock(self);
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFValueChangedNotification object:self];
}

#pragma mark BMFDataReadProtocol

- (NSInteger) numberOfSections {
	return [self.dataStore numberOfSections];
}

- (NSInteger) numberOfRowsInSection:(NSUInteger) section {
	return [self.dataStore numberOfRowsInSection:section];
}

- (NSString *) titleForSection:(NSUInteger)section kind:(NSString *)kind {
	return [self.dataStore titleForSection:section kind:kind];
}

- (id) itemAt:(NSInteger) section row:(NSInteger) row {
	return [self.dataStore itemAt:section row:row];
}

- (id) itemAt:(NSIndexPath *)indexPath {
	return [self.dataStore itemAt:indexPath];
}

- (NSIndexPath *) indexOfItem:(id)item {
	return [self.dataStore indexOfItem:item];
}

- (NSArray *) allItems {
	return [self.dataStore allItems];
}

- (BOOL) isEmpty {
	return [self.dataStore isEmpty];
}

- (BOOL) indexPathInsideBounds:(NSIndexPath *) indexPath {
	if (self.numberOfSections<=indexPath.section) return NO;
	return ([self numberOfRowsInSection:indexPath.section]);
}

- (void) reload {
	[self.dataStore reload];
}

- (void) notifyDataChanged {
	if (self.applyValueBlock) self.applyValueBlock(self);
	if (self.signalBlock) self.signalBlock(self.allItems);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataBatchChangeNotification object:self];
}

@end
