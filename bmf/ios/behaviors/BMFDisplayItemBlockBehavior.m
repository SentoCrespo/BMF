//
//  BMFDisplayItemBlockBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/1/15.
//
//

#import "BMFDisplayItemBlockBehavior.h"

@implementation BMFDisplayItemBlockBehavior

- (void) willDisplay:(id) item atIndexPath:(NSIndexPath *) indexPath view:(UIView *)view containerView:(UIView *) containerView {
	if (self.willDisplayBlock) self.willDisplayBlock(item,indexPath);
}

- (void) didDisplay:(id) item atIndexPath:(NSIndexPath *) indexPath view:(UIView *)view containerView:(UIView *) containerView {
	if (self.didDisplayBlock) self.didDisplayBlock(item,indexPath);
}

@end
