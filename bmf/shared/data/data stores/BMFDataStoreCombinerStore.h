//
//  BMFComplexDataStore.h
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMFDataRead.h"

@interface BMFDataStoreCombinerStore : BMFDataRead

@property (nonatomic, strong) NSArray *dataStores;

- (instancetype) initWithStores:(NSArray *) dataStores;
- (instancetype) init __attribute__((unavailable("Use initWithStores: instead")));

@end
