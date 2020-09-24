//
//  BMFCompoundDataStore.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFCompoundDataStore.h"

#import "BMFTypes.h"

@implementation BMFCompoundDataStore

- (void) findDataStoreForIndexPath:(NSIndexPath *) indexPath completion:(void(^)(id<BMFDataReadProtocol> dataStore,NSIndexPath *storeIndexPath)) completionBlock {
	
	BMFAssertReturn(indexPath);
	BMFAssertReturn(completionBlock);
	
	__block id<BMFDataReadProtocol> finalDataStore = nil;
	__block NSIndexPath *finalIndexPath = nil;
	
	__block NSUInteger currentIndex = indexPath.BMF_section;
//	[self.dataStores enumerateObjectsUsingBlock:^(id<BMFDataReadProtocol> dataStore, NSUInteger idx, BOOL *stop) {
	for (id<BMFDataReadProtocol> dataStore in self.dataStores) {
		if (currentIndex<[dataStore numberOfSections]) {
			finalDataStore = dataStore;
			finalIndexPath = [NSIndexPath BMF_indexPathForRow:indexPath.BMF_row inSection:currentIndex];
			break;
		}
		else {
			currentIndex -= [dataStore numberOfSections];
		}
	}
	
	completionBlock(finalDataStore,finalIndexPath);
}

#pragma mark BMFDataStoreProtocol

- (NSInteger) numberOfSections {
	NSInteger numSections = 0;
	for (id<BMFDataReadProtocol> store in self.dataStores) {
		numSections += [store numberOfSections];
	}
	
	return numSections;
}

- (NSInteger) numberOfRowsInSection:(NSUInteger) section {

	__block id<BMFDataReadProtocol> foundDataStore = nil;
	__block NSIndexPath *foundIndexPath = nil;

	[self findDataStoreForIndexPath:[NSIndexPath BMF_indexPathForRow:0 inSection:section] completion:^(id<BMFDataReadProtocol> dataStore, NSIndexPath *storeIndexPath) {
		foundDataStore = dataStore;
		foundIndexPath = storeIndexPath;
	}];
	
	return [foundDataStore numberOfRowsInSection:foundIndexPath.BMF_section];
}

- (NSString *) titleForSection:(NSUInteger) section kind:(NSString *)kind {
	
	__block id<BMFDataReadProtocol> foundDataStore = nil;
	__block NSIndexPath *foundIndexPath = nil;

	[self findDataStoreForIndexPath:[NSIndexPath BMF_indexPathForRow:0 inSection:section] completion:^(id<BMFDataReadProtocol> dataStore, NSIndexPath *storeIndexPath) {
		foundDataStore = dataStore;
		foundIndexPath = storeIndexPath;
	}];
	
	return [foundDataStore titleForSection:foundIndexPath.BMF_section kind:kind];
}

- (id) itemAt:(NSInteger) section row:(NSInteger) row {
	BMFAssertReturnNil(section>=0);
	BMFAssertReturnNil(row>=0);
	
	__block id<BMFDataReadProtocol> foundDataStore = nil;
	__block NSIndexPath *foundIndexPath = nil;
	[self findDataStoreForIndexPath:[NSIndexPath BMF_indexPathForRow:row inSection:section] completion:^(id<BMFDataReadProtocol> dataStore, NSIndexPath *storeIndexPath) {
		foundDataStore = dataStore;
		foundIndexPath = storeIndexPath;
	}];
	
	BMFAssertReturnNil(foundDataStore);
	BMFAssertReturnNil(foundIndexPath);

	return [foundDataStore itemAt:foundIndexPath];
}


- (id) itemAt:(NSIndexPath *) indexPath {
	return [self itemAt:indexPath.BMF_section row:indexPath.BMF_row];
}

- (NSIndexPath *) indexOfItem:(id) item {
	
	__block NSIndexPath *finalIndexPath = nil;
	
	__block NSUInteger section = 0;
	[self.dataStores enumerateObjectsUsingBlock:^(id<BMFDataReadProtocol> dataStore, NSUInteger idx, BOOL *stop) {
		
		NSIndexPath *indexPath = [dataStore indexOfItem:item];
		if (indexPath) {
			finalIndexPath = [NSIndexPath BMF_indexPathForRow:indexPath.BMF_row inSection:indexPath.BMF_section+section];
		}
		else {
			section++;
		}
	}];
	
	return finalIndexPath;
}

- (NSArray *) allItems {
	NSMutableArray *results = [NSMutableArray array];
	for (id<BMFDataReadProtocol> dataStore in self.dataStores) {
		[results addObjectsFromArray:[dataStore allItems]];
	}
	
	return results;
}

#pragma mark BMFDataStoreProtocol

- (void) startUpdating {
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataWillChangeNotification object:self];
}

- (BOOL) addItem:(id) item {
	id<BMFDataStoreProtocol> lastStore = self.dataStores.lastObject;
	if (![lastStore conformsToProtocol:@protocol(BMFDataStoreProtocol)]) {
		DDLogError(@"Tried to add item but the last data store doesn't support the datastore protocol: %@",lastStore);
		return NO;
	}
	
	if (![lastStore addItem:item]) {
		return NO;
	}
	
	NSIndexPath *finalIndexPath = [self indexOfItem:item];

	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataInsertedNotification object:self userInfo:@{ @"indexPath" : finalIndexPath }];
	return YES;
}

- (BOOL) insertItem:(id) item atIndexPath:(NSIndexPath *) indexPath {
	__block BOOL result = NO;
	// TODO insert item
	[self findDataStoreForIndexPath:indexPath completion:^(id<BMFDataReadProtocol> dataStore, NSIndexPath *storeIndexPath) {
		id<BMFDataStoreProtocol> destinationStore = [NSObject BMF_castObject:dataStore withProtocol:@protocol(BMFDataStoreProtocol)];
		result = [destinationStore insertItem:item atIndexPath:storeIndexPath];
	}];

	if (!result) return NO;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataInsertedNotification object:self userInfo:@{ @"indexPath" : indexPath }];
	
	return YES;
}

- (BOOL) removeItem:(id) item {
	__block BOOL result = NO;
	
	NSIndexPath *indexPath = [self indexOfItem:item];
	[self findDataStoreForIndexPath:indexPath completion:^(id<BMFDataReadProtocol> dataStore, NSIndexPath *storeIndexPath) {
		if (![dataStore conformsToProtocol:@protocol(BMFDataStoreProtocol)]) {
			DDLogError(@"Tried to remove item but the last data store doesn't support the datastore protocol: %@",dataStore);
			return;
		}
		
		id<BMFDataStoreProtocol> store = [NSObject BMF_castObject:dataStore withProtocol:@protocol(BMFDataStoreProtocol)];
		result = [store removeItem:item];
	}];
	
	return result;
}

- (void) endUpdating {
	BMFSupressDeprecationWarning(if (self.applyValueBlock) self.applyValueBlock(self););
	
	if (self.signalBlock) self.signalBlock(self.allItems);
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataDidChangeNotification object:self];
}


- (void) removeAllItems {
	for (id<BMFDataStoreProtocol> dataStore in self.dataStores) {
		if ([dataStore conformsToProtocol:@protocol(BMFDataStoreProtocol)]) {
			[dataStore removeAllItems];
		}
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataBatchChangeNotification object:self];
}

@end
