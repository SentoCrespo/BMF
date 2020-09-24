//
//  NSArray+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 17/12/14.
//
//

#import "NSArray+BMF.h"
#import "BMFUtils.h"

@implementation NSArray (BMF)

- (void) BMF_forEach:(BMFItemBlock)block {
	for (id item in self) {
		block(item);
	}
}

- (id) BMF_reduce:(id) initialValue combine:(BMFCombineBlock)block {
	id result = initialValue;
	for (id object in self) {
		result = block(result,object);
	}
	return result;
}

- (NSArray *) BMF_map:(BMFMapBlock)block {
	BMFAssertReturnNil(block);
	NSMutableArray *results = [NSMutableArray array];
	for (id object in self) {
		id result = block(object);
		if (result) [results addObject:result];
	}
	return [results copy];
}

- (NSArray *) BMF_filter:(BMFFilterBlock)block {
	NSMutableArray *results = [NSMutableArray array];
	for (id object in self) {
		if (block(object)) [results addObject:object];
	}
	return [results copy];
}

- (NSArray *) BMF_tail {
	BMFAssertReturnNil(self.count>0);
	return [self subarrayWithRange:NSMakeRange(1, self.count-1)];
}

- (NSArray *) BMF_arrayByRemovingFirstObject {
	return [self BMF_tail];
}

- (NSArray *) BMF_arrayByRemovingObjectsAtIndexes:(NSArray *) indexes {
	NSMutableArray *results = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (![indexes containsObject:@(idx)]) {
			[results addObject:obj];
		}
	}];
	return [results copy];
}

- (NSArray *) BMF_arrayByRemovingLastObject {
	BMFAssertReturnNil(self.count>0);
	return [self subarrayWithRange:NSMakeRange(0, self.count-1)];
}

- (NSArray *) BMF_arrayByRemovingDuplicates:(BMFArrayItemIdentifierBlock) block {
	BMFAssertReturnNil(block);
	NSMutableArray *results = [NSMutableArray array];
	NSMutableArray *identifiers = [NSMutableArray array];
	for (id item in self) {
		id identifier = block(item);
		if (![identifiers containsObject:identifier]) {
			[identifiers addObject:identifier];
			[results addObject:item];
		}
	}
	return results;
}

- (NSArray *) BMF_flatten {
	NSMutableArray *results = [NSMutableArray array];
	for (NSArray *array in self) {
	
		if (![array isKindOfClass:[NSArray class]]) {
			continue;
		}
		
		[results addObjectsFromArray:array];
	}
	return [results copy];
}

- (NSArray *) BMF_randomSubarrayWithElementCount:(NSUInteger)count {
	BMFAssertReturnNil(count<self.count);
	if (count==self.count) return self;
	
	NSMutableSet *indexes = [NSMutableSet set];
	NSMutableArray *results = [NSMutableArray array];
	while (results.count<count) {
		NSUInteger index = [BMFUtils randomInteger:0 max:self.count-1];
		if ([indexes containsObject:@(index)]) continue;
		
		id item = self[index];
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

- (NSDictionary *) BMF_arrayGroupedBy:(BMFArrayGroupBlock)groupBlock {
	NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
	
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id identifier = groupBlock(obj,idx);
		if (identifier) {
			if (!resultDic[identifier]) {
				resultDic[identifier] = [NSMutableArray array];
			}
			[resultDic[identifier] addObject:obj];
		}
	}];
	
	return [resultDic copy];
}

@end
