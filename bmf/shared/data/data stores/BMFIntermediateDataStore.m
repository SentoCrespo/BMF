//
//  BMFIntermediateDataStore.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 5/11/14.
//
//

#import "BMFIntermediateDataStore.h"

#import <ReactiveCocoa/RACEXTScope.h>

@interface BMFIntermediateDataStore()

@property (nonatomic, strong) NSMutableArray *observationTokens;

@end

@implementation BMFIntermediateDataStore

- (instancetype) initWithStore:(id<BMFDataReadProtocol>)dataStore {
	BMFAssertReturnNil(dataStore);
	
	self = [super init];
	if (self) {
		_dataStore = dataStore;
		[self.progress addChild:_dataStore.progress];
		_observationTokens = [NSMutableArray array];
		[self updateObservers];
	}
	return self;
}

- (void) setDataStore:(id<BMFDataReadProtocol>)dataStore {
	BMFAssertReturn(dataStore);
	_dataStore = dataStore;
	[self.progress addChild:_dataStore.progress];
	
	[self updateObservers];
}

- (void) dealloc {
	[self stopObserving];
}

- (void) updateObservers {
	[self stopObserving];
	
	@weakify(self);

	[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataWillChangeNotification object:_dataStore] subscribeNext:^(NSNotification *note) {
		@strongify(self);
		[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataWillChangeNotification object:self userInfo:note.userInfo];
	}]];
	[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataSectionInsertedNotification object:_dataStore] subscribeNext:^(NSNotification *note) {
		@strongify(self);
		[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataSectionInsertedNotification object:self userInfo:note.userInfo];
	}]];
	[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataSectionDeletedNotification object:_dataStore] subscribeNext:^(NSNotification *note) {
		@strongify(self);
		[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataSectionDeletedNotification object:self userInfo:note.userInfo];
	}]];
	[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataInsertedNotification object:_dataStore] subscribeNext:^(NSNotification *note) {
		@strongify(self);
		[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataInsertedNotification object:self userInfo:note.userInfo];
	}]];
	[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataMovedNotification object:_dataStore] subscribeNext:^(NSNotification *note) {
		@strongify(self);
		[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataMovedNotification object:self userInfo:note.userInfo];
	}]];
	[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataUpdatedNotification object:_dataStore] subscribeNext:^(NSNotification *note) {
		@strongify(self);
		[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataUpdatedNotification object:self userInfo:note.userInfo];
	}]];
	[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataDeletedNotification object:_dataStore] subscribeNext:^(NSNotification *note) {
		@strongify(self);
		[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataDeletedNotification object:self userInfo:note.userInfo];
	}]];
	[self.observationTokens addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataDidChangeNotification object:_dataStore] subscribeNext:^(NSNotification *note) {
		@strongify(self);
		[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataDidChangeNotification object:self userInfo:note.userInfo];
	}]];
	[self.observationTokens addObject:[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataBatchChangeNotification object:_dataStore] deliverOn:[RACScheduler mainThreadScheduler] ] subscribeNext:^(NSNotification *note) {
		@strongify(self);
		[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataBatchChangeNotification object:self userInfo:note.userInfo];
	}]];
}

- (void) stopObserving {
	for (id token in self.observationTokens) {
		[token dispose];
	}
	
	[self.observationTokens removeAllObjects];
}

#pragma mark BMFDataReadProtocol

- (NSInteger) numberOfSections { return [_dataStore numberOfSections]; }
- (NSInteger) numberOfRowsInSection:(NSUInteger) section { return [_dataStore numberOfRowsInSection:section]; }
- (NSString *) titleForSection:(NSUInteger) section kind:(NSString *)kind { return [_dataStore titleForSection:section kind:kind]; }
- (id) itemAt:(NSInteger) section row:(NSInteger) row { return [_dataStore itemAt:section row:row]; }
- (id) itemAt:(NSIndexPath *) indexPath  { return [self itemAt:indexPath.BMF_section row:indexPath.BMF_row]; }
- (NSIndexPath *) indexOfItem:(id) item { return [_dataStore indexOfItem:item]; }
- (NSArray *) allItems { return [_dataStore allItems]; }
- (BOOL) isEmpty { return [_dataStore isEmpty]; }
- (BOOL) indexPathInsideBounds:(NSIndexPath *) indexPath { return [_dataStore indexPathInsideBounds:indexPath]; }

@end
