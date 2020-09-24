//
//  BMFIntermediateDataStore.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 5/11/14.
//
//

#import "BMFDataRead.h"

@interface BMFIntermediateDataStore : BMFDataRead

@property (nonatomic, strong) id<BMFDataReadProtocol> dataStore;

- (instancetype) initWithStore:(id<BMFDataReadProtocol>) dataStore;
- (instancetype) init __attribute__((unavailable("Use initWithStore: instead")));

@end
