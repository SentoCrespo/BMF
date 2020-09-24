//
//  BMFManagedContextOperationsTask.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 13/06/14.
//
//

#import "BMFOperationsTask.h"

@interface BMFManagedContextOperationsTask : BMFOperationsTask

@property (nonatomic, strong) NSManagedObjectContext *context;

/// Num of operations to wait to complete before saving the context. If there are less operations than this enqueued the context will be saved when all of them have finished. 10 by default.
@property (nonatomic, assign) NSUInteger batchCount;

- (instancetype) initWithOperations:(NSArray *) operations inContext:(NSManagedObjectContext *) context;
- (instancetype) init __attribute__((unavailable("Use initWithOperations:inContext: instead")));

@end
