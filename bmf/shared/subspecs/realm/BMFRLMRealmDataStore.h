//
//  BMFRLMRealmDataStore.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/9/14.
//
//

#import "BMFDataStore.h"

#import <Realm/Realm.h>

typedef RLMResults *(^BMFRLMRealmQueryBlock)();

@interface BMFRLMRealmDataStore : BMFDataStore

@property (nonatomic, copy) NSString *sectionHeaderTitle;
@property (nonatomic, copy) NSString *sectionFooterTitle;

@property (nonatomic, copy) BMFRLMRealmQueryBlock queryBlock;
@property (nonatomic, strong) RLMRealm *realm;

- (instancetype) initWithQueryBlock:(BMFRLMRealmQueryBlock) queryBlock realm:(RLMRealm *)realm;
- (instancetype) init __attribute__((unavailable("Use initWithQueryBlock:realm: instead")));

@end
