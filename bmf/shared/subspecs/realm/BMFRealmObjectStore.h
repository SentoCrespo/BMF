//
//  BMFRealmObjectStore.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/10/14.
//
//

#import "BMFObjectDataStore.h"

@class RLMRealm, RLMObject;

typedef RLMObject *(^BMFRealmObjectQueryBlock)();

@interface BMFRealmObjectStore : BMFValue

@property (nonatomic, copy) BMFRealmObjectQueryBlock queryBlock;
@property (nonatomic, strong) RLMRealm *realm;

- (instancetype) initWithQueryBlock:(BMFRealmObjectQueryBlock) queryBlock realm:(RLMRealm *) realm;
- (instancetype) init __attribute__((unavailable("Use initWithQueryBlock:realm: instead")));

@end
