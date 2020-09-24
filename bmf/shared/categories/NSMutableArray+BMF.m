//
//  NSMutableArray+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 6/11/14.
//
//

#import "NSMutableArray+BMF.h"

@implementation NSMutableArray (BMF)

- (void) BMF_addObjectSafe:(id) object {
	if (!object) return;
	[self addObject:object];
}

@end
