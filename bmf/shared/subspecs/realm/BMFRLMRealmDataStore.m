//
//  BMFRLMRealmDataStore.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/9/14.
//
//

#import "BMFRLMRealmDataStore.h"

#import "BMF.h"
#import "RLMResults+BMF.h"

@interface BMFRLMRealmDataStore()

@property (nonatomic, strong) RLMResults *cachedArray;

@end

@implementation BMFRLMRealmDataStore {
	id realmObserver;
}

- (instancetype) initWithQueryBlock:(BMFRLMRealmQueryBlock) queryBlock realm:(RLMRealm *)realm {
	BMFAssertReturnNil(queryBlock);
	BMFAssertReturnNil(realm);
	
	self = [super init];
	if (self) {
		_queryBlock = [queryBlock copy];
		_realm = realm;
	}
	return self;
}

- (void) dealloc {
	[self stopObserving];
}

- (void) setRealm:(RLMRealm *)realm {
	BMFAssertReturn(realm);
	_realm = realm;
}

#pragma mark Accessors

- (void) setQueryBlock:(BMFRLMRealmQueryBlock)queryBlock {
	BMFAssertReturn(queryBlock);
	
	_queryBlock = [queryBlock copy];
}

- (void) reload {
	[self.progress start:@"RealmDataStore"];
	
	self.cachedArray = self.queryBlock();
	
	NSError *error = nil;
	if (!self.cachedArray) {
		error = [NSError errorWithDomain:@"DataStore" code:BMFErrorData userInfo:@{ NSLocalizedDescriptionKey : BMFLocalized(@"Unknown error loading data", nil) }];
	}
		
	[self.progress stop:error];
	
	[self notifyDataChanged];
	
	[self startObserving];
}

#pragma mark Observation

- (void) startObserving {
	[self stopObserving];
	
	RLMObject *object = self.cachedArray.firstObject;
	if (!object) return;
	
	realmObserver = [self.realm addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
		[self reload];
	}];
}

- (void) stopObserving {
	[self.realm removeNotification:realmObserver];
	realmObserver = nil;
}

#pragma mark BMFDataReadProtocol

- (NSInteger) numberOfSections {
	if (!self.cachedArray) {
		[self reload];
	}
		
	if (self.cachedArray.count>0) return 1;
	return 0;
}

- (NSInteger) numberOfRowsInSection:(NSUInteger) section {
	if (!self.cachedArray) {
		[self reload];
	}
	
	return self.cachedArray.count;
}

- (id) itemAt:(NSIndexPath *) indexPath {
	return self.cachedArray[indexPath.BMF_row];
}

- (NSIndexPath *) indexOfItem:(id) item {
	NSUInteger index = [self.cachedArray indexOfObject:item];
	if (index!=NSNotFound) {
		return [NSIndexPath BMF_indexPathForRow:index inSection:0];
	}
	return nil;
}

- (NSArray *) allItems {
	return [self.cachedArray BMF_allObjects];
}

- (BOOL) isEmpty {
	return self.cachedArray.count==0;
}

#pragma mark BMFDataStore

- (void) performStartUpdating {
	[self.realm beginWriteTransaction];
}

- (NSIndexPath *) performAddItem:(id) item {
	RLMObject *object = [RLMObject BMF_cast:item];
	BMFAssertReturnNil(object);
	
	[self.realm addObject:item];
	
	return [NSIndexPath BMF_indexPathForRow:NSNotFound inSection:0]; // Unknown
}

/// Returns the indexPath of the inserted item or nil if it wasn't inserted. Might not necessarily be equal to the indexPath parameter
- (NSIndexPath *) performInsertItem:(id) item atIndexPath:(NSIndexPath *) indexPath {
	RLMObject *object = [RLMObject BMF_cast:item];
	BMFAssertReturnNil(object);

	[self.realm addObject:item];

	return [NSIndexPath BMF_indexPathForRow:NSNotFound inSection:0]; // Unknown
}

/// Returns the indexPath of the removed item or nil if it wasn't added
- (NSIndexPath *) performRemoveItem:(id) item {
	RLMObject *object = [RLMObject BMF_cast:item];
	BMFAssertReturnNil(object);
	
	NSIndexPath *indexPath = [self indexOfItem:object];
	[self.realm deleteObject:object];
	return indexPath;
}

- (void) performEndUpdating {
	[self.realm commitWriteTransaction];
}

- (void) performRemoveAllItems {
	[self.realm deleteAllObjects];
}

- (void) performSetItems:(id) items {
	[self.realm addObjects:items];
}

@end
