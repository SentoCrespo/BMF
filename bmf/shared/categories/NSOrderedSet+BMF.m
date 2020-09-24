//
//  NSOrderedSet+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 4/2/15.
//
//

#import "NSOrderedSet+BMF.h"

@implementation NSOrderedSet (BMF)

- (void) BMF_forEach:(BMFItemBlock)block {
	for (id item in self) {
		block(item);
	}
}

- (NSOrderedSet *) BMF_map:(BMFMapBlock)block {
	NSMutableArray *results = [NSMutableArray array];
	for (id object in self) {
		id result = block(object);
		if (result) [results addObject:result];
	}
	return [NSOrderedSet orderedSetWithArray:results];
}

- (NSOrderedSet *) BMF_filter:(BMFFilterBlock)block {
	NSMutableArray *results = [NSMutableArray array];
	for (id object in self) {
		if (block(object)) [results addObject:object];
	}
	return [NSOrderedSet orderedSetWithArray:results];
}

- (id) BMF_findFirst:(BMFFilterBlock)block {
	for (id object in self) {
		if (block(object)) return object;
	}
	return nil;
}

@end
