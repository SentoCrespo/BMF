//
//  NSMutableOrderedSet+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/2/15.
//
//

#import "NSMutableOrderedSet+BMF.h"

@implementation NSMutableOrderedSet (BMF)

- (void) BMF_addObjectSafe:(id) object {
	if (!object) return;
	[self addObject:object];
}

- (void) BMF_forEach:(BMFItemBlock)block {
	for (id item in self) {
		block(item);
	}
}

- (NSMutableOrderedSet *) BMF_map:(BMFMapBlock)block {
	NSMutableArray *results = [NSMutableArray array];
	for (id object in self) {
		id result = block(object);
		if (result) [results addObject:result];
	}
	return [NSMutableOrderedSet orderedSetWithArray:results];
}

- (NSMutableOrderedSet *) BMF_filter:(BMFFilterBlock)block {
	NSMutableArray *results = [NSMutableArray array];
	for (id object in self) {
		if (block(object)) [results addObject:object];
	}
	return [NSMutableOrderedSet orderedSetWithArray:results];
}

@end
