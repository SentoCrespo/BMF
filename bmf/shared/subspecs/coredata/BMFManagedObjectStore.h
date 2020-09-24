//
//  BMFManagedObjectDataStore.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 19/05/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFObjectDataStore.h"

#import <CoreData/CoreData.h>

@interface BMFManagedObjectStore : BMFObjectDataStore

@property (nonatomic, strong) NSManagedObject *value;


@end
