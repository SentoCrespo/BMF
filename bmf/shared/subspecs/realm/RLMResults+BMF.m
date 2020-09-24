//
//  RLMResults+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 7/11/14.
//
//

#import "RLMResults+BMF.h"

@implementation RLMResults (BMF)

- (NSArray *) BMF_allObjects {
	NSMutableArray *results = [NSMutableArray array];
	for (id item in self) {
		[results addObject:item];
	}
	
	return [results copy];
}

@end
