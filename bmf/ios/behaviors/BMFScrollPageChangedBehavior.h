//
//  BMFScrollPageChangedBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/1/15.
//
//

#import "BMFScrollViewViewControllerBehavior.h"

typedef void(^BMFPageIndexBlock)(NSInteger pageIndex);

@interface BMFScrollPageChangedBehavior : BMFScrollViewViewControllerBehavior

@property (nonatomic, copy) BMFPageIndexBlock pageChangedBlock;

- (instancetype) initWithView:(UIScrollView *)scrollView actionBlock:(BMFPageIndexBlock) pageChangedBlock;

@end
