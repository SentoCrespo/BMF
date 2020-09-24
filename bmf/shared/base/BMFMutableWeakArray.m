//
//  BMFMutableWeakArray.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFMutableWeakArray.h"
#import "BMFWeakObject.h"

#import "BMF.h"

@interface BMFMutableWeakArray()

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end


@implementation BMFMutableWeakArray

- (instancetype)init
{
    self = [super init];
    if (self) {
		_serialQueue = dispatch_queue_create("BMF Mutable array queue", DISPATCH_QUEUE_SERIAL);
		
		dispatch_sync(_serialQueue, ^{
			_array = [NSMutableArray array];
		});
    }
    return self;
}

- (id) objectAtIndexedSubscript:(NSUInteger) index {
	__block BMFWeakObject *obj = nil;
	
	dispatch_sync(_serialQueue, ^{
		obj = [self.array objectAtIndexedSubscript:index];
	});

	return obj.object;
}

- (void) setObject:(id)object atIndexedSubscript:(NSUInteger)idx {
	BMFWeakObject *weak = [[BMFWeakObject alloc] initWithObject:object];
	
	dispatch_async(_serialQueue, ^{
		[self.array setObject:weak atIndexedSubscript:idx];
	});
}

- (void) insertObject:(id) object atIndex:(NSUInteger)index {
	BMFWeakObject *weak = [[BMFWeakObject alloc] initWithObject:object];
	
	dispatch_async(_serialQueue, ^{
		[self.array insertObject:weak atIndex:index];
	});
}

- (void) insertObjects:(NSArray *) objects atIndexes:(NSIndexSet *)indexes {
	NSMutableArray *weakObjects = [NSMutableArray array];
	for (id object in objects) {
		BMFWeakObject *weak = [[BMFWeakObject alloc] initWithObject:object];
		[weakObjects addObject:weak];
	}
	
	dispatch_async(_serialQueue, ^{
		[self.array insertObjects:weakObjects atIndexes:indexes];
	});
}

- (void) addObject:(id) object {
	BMFWeakObject *weak = [[BMFWeakObject alloc] initWithObject:object];
	
	dispatch_async(_serialQueue, ^{
		[self.array addObject:weak];
	});
}

- (id) objectAtIndex:(NSUInteger)index {
	__block BMFWeakObject *weak = nil;
	
	dispatch_sync(_serialQueue, ^{
		weak = [self.array objectAtIndex:index];
	});
	
	return weak.object;
}

- (void) removeObject:(id)anObject {
	dispatch_async(_serialQueue, ^{
		[self.array removeObject:anObject];
	});
}

- (void) removeObjectAtIndex:(NSUInteger)index {
	dispatch_async(_serialQueue, ^{
		[self.array removeObjectAtIndex:index];
	});
}

- (void) removeAllObjects {
	dispatch_async(_serialQueue, ^{
		[self.array removeAllObjects];
	});
}

- (void) removeLastObject {
	
	dispatch_async(_serialQueue, ^{
		[self purgeEmptyObjects];
		[self.array removeLastObject];
	});
}

- (NSUInteger) count {
	
	__block NSUInteger result = 0;
	dispatch_sync(_serialQueue, ^{
		
		[self purgeEmptyObjects];
		
		result = self.array.count;
	});
	
	return result;
}

- (void) purgeEmptyObjects {
	NSMutableArray *objectsToDelete = [NSMutableArray array];
//	NSArray *arrayCopy = [self.array copy];
	for (BMFWeakObject *weak in self.array) {
		if (!weak.object) {
			[objectsToDelete addObject:weak];
		}
	}
	
//	if (objectsToDelete.count>0) DDLogInfo(@"Deleting some objects from mutablearray: %@",objectsToDelete);
	[self.array removeObjectsInArray:objectsToDelete];
}

@end
