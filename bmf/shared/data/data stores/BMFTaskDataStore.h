//
//  BMFTaskDataStore.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 5/11/14.
//
//

#import "BMFIntermediateDataStore.h"

#import "BMFTaskProtocol.h"

typedef id<BMFTaskProtocol>(^BMFCreateTaskBlock)();

typedef NS_ENUM(NSUInteger, BMFTaskDataStoreMode) {
	BMFTaskDataStoreAlwaysRunTask,
	BMFTaskDataStoreRunTaskIfEmpty
};

/// This class creates a task using the passed block and runs it every time it is requested data.
@interface BMFTaskDataStore : BMFIntermediateDataStore

@property (nonatomic, copy) BMFCreateTaskBlock createTaskBlock;
@property (nonatomic, strong) id<BMFDataReadProtocol> dataStore;

/// When should the task run. BMFTaskDataStoreRunTaskIfEmpty by default
@property (nonatomic, assign) BMFTaskDataStoreMode mode;

- (instancetype) initWithTaskBlock:(BMFCreateTaskBlock)createTaskBlock dataStore:(id<BMFDataReadProtocol>)dataStore;

- (instancetype) initWithStore:(id<BMFDataReadProtocol>)dataStore __attribute__((unavailable("Use initWithTaskBlock:dataStore: instead")));
- (instancetype) init __attribute__((unavailable("Use initWithTaskBlock:dataStore: instead")));

@end
