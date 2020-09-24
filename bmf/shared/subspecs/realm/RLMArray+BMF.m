//
//  RLMArray+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/09/14.
//
//

#import "RLMArray+BMF.h"

@implementation RLMArray (BMF)

- (NSArray *) BMF_allObjects {
	NSMutableArray *results = [NSMutableArray array];
	for (id item in self) {
		[results addObject:item];
	}
	
	return [results copy];
}

@end
