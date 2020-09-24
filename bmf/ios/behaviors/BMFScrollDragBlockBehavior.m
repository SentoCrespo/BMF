//
//  BMFScrollDragBlockBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/07/14.
//
//

#import "BMFScrollDragBlockBehavior.h"

@implementation BMFScrollDragBlockBehavior

- (instancetype) initWithView:(UIScrollView *)scrollView actionBlock:(BMFActionBlock) block {
	BMFAssertReturnNil(block);
	
    self = [super initWithView:scrollView];
    if (self) {
		_actionBlock = [block copy];
    }
    return self;
}

- (void) setActionBlock:(BMFActionBlock)actionBlock {
	BMFAssertReturn(actionBlock);
	
	_actionBlock = [actionBlock copy];
}

#pragma mark UIScrollViewDelegate

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	self.actionBlock(self);
}

@end
