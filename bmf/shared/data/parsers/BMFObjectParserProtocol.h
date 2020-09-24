//
//  BMFObjectParserProtocol.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/05/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFProgress.h"

@protocol BMFObjectParserDelegateProtocol <NSObject>

@optional

- (void) didCreateObject:(id) object;
- (void) didParseObject:(id)object withServerObject:(NSDictionary *) serverObject;
- (void) didFailToParseObject:(id)object withServerObject:(NSDictionary *) serverObject;
- (BOOL) shouldCreateObjectForServerObject:(id) serverObject;
- (BOOL) shouldDeleteObject:(id) object;
- (void) didDeleteObject:(id) object;

@end

@protocol BMFObjectParserProtocol <NSObject>

- (id) parseServerObject:(id)serverObject error:(NSError **) error;
- (id) newObjectFromServerObject:(id) serverObject;
- (BOOL)updateLocalObject:(id) object withServerObject:(id)serverObject error:(NSError **) error;

@optional

// These methods are only required if we have persistence

- (NSArray *) fetchAllLocalObjectsSortedById;

- (NSComparisonResult) compareServerObject:(id) obj1 withServerObject:(id)obj2;
- (NSComparisonResult) compareLocalObject:(id) obj1 withLocalObject:(id)obj2;
- (NSComparisonResult) compareLocalObject:(id) obj1 withServerObject:(id)obj2;

- (BOOL) deleteObject:(id) object;
- (BOOL) deleteAllLocalObjects;

- (BOOL) saveChanges;

@end

@protocol BMFObjectSerializerProtocol <NSObject>

- (BOOL)updateServerObject:(id) serverObject withLocalObject:(id)object error:(NSError **) error;

@end
