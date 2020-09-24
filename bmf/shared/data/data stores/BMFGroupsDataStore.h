//
//  BMFGroupsDataStore.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 04/07/14.
//
//

#import "BMFDataStoreModifierStore.h"

typedef NSArray *(^BMFGroupChildrenBlock)(id group);


/// A data sotre that gets 1 data store as input. Accept items that have other items, and it will unfold them to show groups and children in the same list. For example, if the input is an array data store with 2 sections with 1 item each that is a group with 3 children, the result will be 2 sections with 4 items each
@interface BMFGroupsDataStore : BMFDataStoreModifierStore

@property (nonatomic, copy) BMFGroupChildrenBlock childrenBlock;

- (instancetype) initWithDataStore:(id<BMFDataReadProtocol>) dataStore childrenBlock:(BMFGroupChildrenBlock) childrenBlock;

@end
