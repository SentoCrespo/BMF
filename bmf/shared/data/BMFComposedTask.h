//
//  BMFComposedTask.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 8/4/15.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"
#import "BMFTaskProtocol.h"
#import "BMFActionableProtocol.h"

typedef NS_ENUM(NSUInteger, BMFComposedTaskMode) {
	BMFComposedTaskWaitForAll, // Wait for all tasks to finish, then call completionBlock
	BMFComposedTaskNotifyAll, // Call completionBlock for each finished task
	BMFComposedTaskNotifyOnlyFirst // Call completionBlock only when the first task finishes
};

@interface BMFComposedTask : NSObject <BMFTaskProtocol, BMFActionableProtocol>

@property (nonatomic, nonnull) BMFProgress *progress;
@property (nonatomic, copy, nonnull) NSArray *tasks;
@property (nonatomic) BMFComposedTaskMode mode; // BMFComposedTaskNotifyAll by default

#pragma mark Actionable

- (void) action:(nullable id)input completion:(nonnull BMFCompletionBlock)completion;

- (nonnull instancetype) initWithTasks:(nonnull NSArray *) tasks;

@end
