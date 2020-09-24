//
//  BMFCompoundDataStore.h
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFDataStoreCombinerStore.h"
#import "BMFDataStoreProtocol.h"

/// Adds original data stores without mixing sections (1 data store with 1 section + 1 data store with 2 sections -> 3 sections)
@interface BMFCompoundDataStore : BMFDataStoreCombinerStore <BMFDataStoreProtocol>

@end
