//
//  NSDictionary+BMFUtils.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/01/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import "NSDictionary+BMF.h"

@implementation NSDictionary (BMF)

- (id) BMF_firstValueForKeys:(NSArray *) keys {
	id result = nil;
	for (NSString *key in keys) {
		result = self[key];
		if (result) return result;
	}
	return result;
}

- (NSDictionary *) BMF_map:(BMFMapBlock)block {
	BMFAssertReturnNil(block);
	
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	
	for (NSString *key in self) {
		id changedValue = block(self[key]);
		if (changedValue) result[key] = changedValue;
    }
	
	return [result copy];
}

- (NSDictionary *) BMF_filter:(BMFFilterBlock)block {
	BMFAssertReturnNil(block);
	
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	
	for (NSString *key in self) {
		id value = self[key];
		if (block(value)) {
			result[key] = value;
		}
    }
	
	return [result copy];
}

@end
