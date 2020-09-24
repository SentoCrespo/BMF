//
//  NSMutableSet+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 6/11/14.
//
//

#import "NSMutableSet+BMF.h"

@implementation NSMutableSet (BMF)

- (void) BMF_addObjectSafe:(id) object {
	if (!object) return;
	[self addObject:object];
}

@end
