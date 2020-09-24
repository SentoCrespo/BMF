//
//  BMFRLMArrayDataStore.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/09/14.
//
//

#import "BMFDataRead.h"

#import "BMFDataStore.h"

#import <Realm/Realm.h>

@interface BMFRLMArrayDataStore : BMFDataStore

@property (nonatomic, copy) NSString *sectionHeaderTitle;
@property (nonatomic, copy) NSString *sectionFooterTitle;

/// This should only be used by subclasses
@property (nonatomic, strong) RLMArray *storedItems;

@end
