//
//  BMFRLMArrayDataStore.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/09/14.
//
//

#import "BMFRLMArrayDataStore.h"

@implementation BMFRLMArrayDataStore {
	RLMRealm *observedRealm;
	id realmObserver;
}

- (void) dealloc {
	[self stopObserving];
}

#pragma mark BMFDataStore template methods

- (NSIndexPath *) performAddItem:(id) item {
	[self.storedItems addObject:item];
	return [NSIndexPath BMF_indexPathForRow:self.storedItems.count-1 inSection:0];
}

- (NSIndexPath *) performInsertItem:(id) item atIndexPath:(NSIndexPath *) indexPath {
	BMFAssertReturnNO(indexPath.BMF_section==0);
	BMFAssertReturnNO(indexPath.BMF_row<self.storedItems.count);
	
	[self.storedItems insertObject:item atIndex:indexPath.BMF_row];
	return [NSIndexPath BMF_indexPathForRow:self.storedItems.count-1 inSection:0];
}

- (NSIndexPath *) performRemoveItem:(id) item {
	NSInteger index = [self.storedItems indexOfObject:item];
	if (index==NSNotFound) {
		return nil;
	}
	
	[self.storedItems removeObjectAtIndex:index];
	return [NSIndexPath BMF_indexPathForRow:index inSection:0];
}

- (void) performRemoveAllItems {
	[self.storedItems removeAllObjects];
}

- (void) performSetItems:(id) items {
	BMFAssertReturn([items isKindOfClass:[RLMArray class]]);
	
	_storedItems = items;
}

#pragma mark Observation

- (void) startObserving {
	[self stopObserving];
	
	RLMObject *object = self.storedItems.firstObject;
	if (!object) return;
	
	observedRealm = object.realm;
	realmObserver = [observedRealm addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
		[self notifyDataChanged];
	}];
}

- (void) stopObserving {
	[observedRealm removeNotification:realmObserver];
	realmObserver = nil;
	observedRealm = nil;
}

#pragma mark TNDataReadProtocol

- (NSInteger) numberOfSections {
	if (self.storedItems.count>0) return 1;
	return 0;
}

- (NSInteger) numberOfRowsInSection:(NSUInteger) section {
	return [self.storedItems count];
}

- (NSString *) titleForSection:(NSUInteger)section kind:(NSString *)kind {
	if ([kind isEqualToString:BMFViewKindSectionHeader]) return self.sectionHeaderTitle;
	return self.sectionFooterTitle;
}

- (id) itemAt:(NSInteger) section row:(NSInteger) row {
	BMFAssertReturnNil(section==0);
	BMFAssertReturnNil(row>=0);
	BMFAssertReturnNil(row<self.storedItems.count);
	
	return self.storedItems[row];
}

- (id) itemAt:(NSIndexPath *) indexPath {
	return [self itemAt:indexPath.BMF_section row:indexPath.BMF_row];
}

- (NSIndexPath *) indexOfItem:(id) item {
	if (!item) return nil;
	NSUInteger row = [self.allItems indexOfObject:item];
	if (row==NSNotFound) return nil;
	return [NSIndexPath BMF_indexPathForRow:row inSection:0];
}


- (NSArray *) allItems {
	
	NSMutableArray *results = [NSMutableArray array];
	
	for (id item in self.storedItems) {
		[results addObject:item];
	}
	
	return results;
}

- (void) reload {
}

- (BOOL) isEmpty {
	return (self.storedItems.count==0);
}

@end
