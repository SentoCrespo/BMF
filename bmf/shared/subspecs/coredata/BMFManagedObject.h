//
//  BMFManagedObject.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/01/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "BMFTypes.h"

@class BMFTaskManager;

@interface BMFManagedObject : NSManagedObject

@property (nonatomic, assign) BOOL BMF_isDeleted;
@property (nonatomic, strong) NSMutableArray *subscriptions;
@property (nonatomic, strong) BMFTaskManager *taskManager;

+ (id) cachedObjectWithKey:(id) key;
+ (void) setCachedObject: (id) object key:(id)key;

- (void) performInit __attribute((objc_requires_super));

- (void) setupRemoteDataProperty:(NSString *) urlPropertyName dataPropertyName:(NSString *) dataPropertyName save:(BOOL)save;
- (void) setupRemoteImageProperty:(NSString *) urlPropertyName dataPropertyName:(NSString *) dataPropertyName imagePropertyName:(NSString *) imagePropertyName save:(BOOL)save;

@end
