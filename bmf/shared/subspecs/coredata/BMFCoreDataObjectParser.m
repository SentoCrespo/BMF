//
//  BMFCoreDataObjectParser.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/05/14.
//
//

#import "BMFCoreDataObjectParser.h"

#import "BMF.h"

#import <MagicalRecord/MagicalRecord.h>

@implementation BMFCoreDataObjectParser

- (instancetype) initWithContext:(NSManagedObjectContext *)context {
	self = [super init];
    if (self) {
		self.context = context;
	}
    return self;
}

- (id) newObject {
	BMFAbstractMethod();
	return nil;
}

- (NSArray *) fetchAllLocalObjectsSortedById {
	BMFAbstractMethod();
	return nil;
}

- (NSComparisonResult) compareDictionary:(NSDictionary *) obj1 withDictionary:(NSDictionary *)obj2 {
	BMFAbstractMethod();
	return NSOrderedSame;
}

- (NSComparisonResult) compareObject:(NSManagedObject *)obj1 withDictionary:(NSDictionary *)obj2 {
	BMFAbstractMethod();
	return NSOrderedSame;
}

- (NSComparisonResult) compareObject:(NSManagedObject *)obj1 withObject:(NSManagedObject *)obj2 {
	BMFAbstractMethod();
	return NSOrderedSame;
}

- (BOOL) updateObject:(NSManagedObject *)object withDictionary:(NSDictionary *) dic error:(NSError **) error {
	BMFAbstractMethod();
	return NO;
}

- (BOOL) deleteObject:(NSManagedObject *)object {
	[self.context deleteObject:object];
	return YES;
}

- (BOOL) deleteAllLocalObjects {
	BMFAbstractMethod();
	return NO;
}

- (BOOL) saveChanges {
	NSError *error = nil;
	BOOL result = [self.context save:&error];
	if (!result) {
		DDLogError(@"Error saving context: %@",error);
	}
	return result;
}

@end

