//
//  BMFDisposableObjectDataStore.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 28/08/14.
//
//

#import "BMFValueProtocol.h"

typedef id(^BMFCreationBlock)();

/// This data store will release the object if a memory warning or a dispose message is received. If the object is needed it will be created again using the block
@interface BMFDisposableObjectDataStore : NSObject <BMFValueProtocol>

@property (nonatomic, strong) id<BMFAdapterProtocol> valueAdapter;

@property (nonatomic, copy) BMFCreationBlock creationBlock;

- (instancetype) initWithCreationBlock:(BMFCreationBlock) creationBlock;
- (instancetype) init __attribute__((unavailable("Use initWithCreationBlock: instead")));

- (void) dispose;

@end
