//
//  BMFScrollDragBlockBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/07/14.
//
//

#import "BMFScrollViewViewControllerBehavior.h"

#import "BMFTypes.h"

@interface BMFScrollDragBlockBehavior : BMFScrollViewViewControllerBehavior

@property (nonatomic, copy) BMFActionBlock actionBlock;

- (instancetype) initWithView:(UIScrollView *)scrollView actionBlock:(BMFActionBlock) block;

@end
