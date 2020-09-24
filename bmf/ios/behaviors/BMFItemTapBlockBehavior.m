//
//  BMFItemTapBlockBehavior.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFItemTapBlockBehavior.h"

#import "BMF.h"
#import "BMFDataSourceProtocol.h"
#import "BMFDataReadProtocol.h"

@implementation BMFItemTapBlockBehavior

- (instancetype) initWithView:(UIView *)view tapBlock:(BMFItemActionBlock)tapBlock {
	BMFAssertReturnNil(view);
	BMFAssertReturnNil(tapBlock);
	
    self = [super init];
    if (self) {
		self.view = view;
        self.itemTapBlock = tapBlock;
		self.deselectAutomatically = YES;
    }
    return self;
}

- (instancetype)init {
	[NSException raise:@"Tap block is required" format:@"use initWithTapBlock: instead"];
	return nil;
}

- (void) itemTapped:(id)item atIndexPath:(NSIndexPath *) indexPath containerView:(UIView *)containerView {
	self.itemTapBlock(item,indexPath);
}

- (void) accessoryItemTapped:(id)item atIndexPath:(NSIndexPath *)indexPath containerView:(UIView *)containerView {
	if (self.accessoryItemTapBlock) self.accessoryItemTapBlock(item,indexPath);
}

@end
