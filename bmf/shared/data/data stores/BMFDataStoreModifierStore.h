//
//  BMFDataStoreModifierStore.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/07/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFDataRead.h"

@interface BMFDataStoreModifierStore : BMFDataRead

@property (nonatomic, strong) id<BMFDataReadProtocol> dataStore;

- (instancetype) initWithDataStore:(id<BMFDataReadProtocol>) dataStore;

@end
