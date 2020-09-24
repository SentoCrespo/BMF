//
//  BMFLoadTaskBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/11/14.
//
//

#import "BMFViewControllerBehavior.h"

#import "BMFTypes.h"

#import "BMFTaskProtocol.h"
#import "BMFLoaderViewProtocol.h"
#import "BMFReloadStrategyProtocol.h"

typedef BOOL(^BMFTaskResultCheckBlock)(id result, NSError *error);
typedef id<BMFTaskProtocol>(^BMFCreateTaskBlock)();

@interface BMFRunTaskBehavior : BMFViewControllerBehavior

@property (nonatomic, copy) BMFCreateTaskBlock createTaskBlock;
@property (nonatomic, copy) BMFCompletionBlock completionBlock;

/// By default this will check that result is not nil
@property (nonatomic, copy) BMFTaskResultCheckBlock checkResultBlock;
@property (nonatomic, strong) id<BMFLoaderViewProtocol> loader;

/// BMFOnlyOnceOKReloadStrategy by default
@property (nonatomic, copy) id<BMFReloadStrategyProtocol> reloadStrategy;

- (instancetype) initWithCreateTaskBlock:(BMFCreateTaskBlock) createTaskBlock completionBlock:(BMFCompletionBlock) completionBlock loader:(id<BMFLoaderViewProtocol>)loader;

- (void) reload;
- (void) forceReload;

@end
