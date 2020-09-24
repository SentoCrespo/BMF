//
//  BMFTaskDataStore.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 5/11/14.
//
//

#import "BMFTaskDataStore.h"

#import "BMF.h"

@implementation BMFTaskDataStore

@dynamic dataStore;

- (instancetype) initWithTaskBlock:(BMFCreateTaskBlock)createTaskBlock dataStore:(id<BMFDataReadProtocol>)dataStore {
	BMFAssertReturnNil(createTaskBlock);
	
	self = [super initWithStore:dataStore];
	if (self) {
		_createTaskBlock = [createTaskBlock copy];
		_mode = BMFTaskDataStoreRunTaskIfEmpty;
	}
	return self;
}

- (void) checkReload {
	if (_mode==BMFTaskDataStoreAlwaysRunTask || [self.dataStore isEmpty]) {
		[self reload];
	}
}

- (void) reload {
	if (self.progress.running) return;
	
	id<BMFTaskProtocol> task = _createTaskBlock();
	[self.progress addChild:task.progress];
	[task run:^(id result, NSError *error) {
		if (!result) {
			DDLogError(@"Error running task: %@",error);
			return;
		}
		
		id<BMFDataReadProtocol, BMFDataStoreProtocol> store = [NSObject BMF_castObject:self.dataStore withProtocol:@protocol(BMFDataStoreProtocol)];
		if (store) {
			[store setItems:result];
		}
		else {
			[self notifyDataChanged];
		}
	}];
}

#pragma mark BMFDataReadProtocol

- (NSInteger) numberOfSections {
	[self checkReload];
	return [super numberOfSections];
}

- (NSInteger) numberOfRowsInSection:(NSUInteger) section {
	[self checkReload];
	return [super numberOfRowsInSection:section];
}

- (NSArray *) allItems {
	[self checkReload];
	return [super allItems];
}


@end
