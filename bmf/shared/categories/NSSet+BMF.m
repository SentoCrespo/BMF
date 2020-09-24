//
//  NSSet+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/1/15.
//
//

#import "NSSet+BMF.h"
#import "BMFUtils.h"

@implementation NSSet (BMF)

- (void) BMF_forEach:(BMFItemBlock)block {
	for (id item in self) {
		block(item);
	}
}

- (NSSet *) BMF_map:(BMFMapBlock)block {
	NSMutableArray *results = [NSMutableArray array];
	for (id object in self) {
		id result = block(object);
		if (result) [results addObject:result];
	}
	return [NSSet setWithArray:results];
}

- (NSSet *) BMF_filter:(BMFFilterBlock)block {
	NSMutableArray *results = [NSMutableArray array];
	for (id object in self) {
		if (block(object)) [results addObject:object];
	}
	return [NSSet setWithArray:results];
}

- (NSSet *) BMF_randomSubsetWithElementCount:(NSUInteger)count {
	BMFAssertReturnNil(count<self.count);
	if (count==self.count) return self;
	
	NSArray *array = [self allObjects];
	
	NSMutableSet *results = [NSMutableSet set];
	while (results.count<count) {
		id item = array[[BMFUtils randomInteger:0 max:self.count-1]];
		[results addObject:item];
	}
	
	return [results copy];
}

- (id) BMF_findFirst:(BMFFilterBlock)block {
	for (id object in self) {
		if (block(object)) return object;
	}
	return nil;
}

@end
