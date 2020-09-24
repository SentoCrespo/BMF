//
//  BMFGroup.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFGroup.h"

@implementation BMFGroup

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.children = [NSArray array];
    }
    return self;
}

- (void) dealloc {
	for (BMFGroup *child in self.children) {
		child.parent = nil;
	}
}

- (void) setParent:(BMFGroup *)parent {
	_parent = parent;
	if (![parent.children containsObject:self])	parent.children = [parent.children arrayByAddingObject:self];
}

@end
