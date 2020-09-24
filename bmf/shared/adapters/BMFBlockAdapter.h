//
//  BMFBlockAdapter.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 22/09/14.
//
//

#import "BMFAdapter.h"

typedef id(^BMFAdapterBlock)(id value);


@interface BMFBlockAdapter : BMFAdapter

@property (nonatomic, copy) BMFAdapterBlock adapterBlock;

- (instancetype) initWithBlock:(BMFAdapterBlock) adapterBlock;
- (instancetype) init __attribute__((unavailable("Use initWithBlock: instead")));

@end
