//
//  BMFBlockCellRegister.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/02/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFCellRegister.h"

typedef void(^BMFCellRegisterCellsBlock)(UIView *containerView);
typedef NSString *(^BMFCellIdBlock)(id detailItem,NSIndexPath *indexPath);
typedef UIView *(^BMFCellViewBlock)(NSString *cellId);

@interface BMFBlockCellRegister : BMFCellRegister

@property (nonatomic, copy) BMFCellViewBlock retrieveCellBlock;

- (instancetype) initWithRegisterBlock:(BMFCellRegisterCellsBlock) registerBlock dequeueBlock:(BMFCellIdBlock) cellIdBlock;
- (instancetype) init __attribute__((unavailable("Use initWithRegisterBlock:dequeueBlock: instead")));

@end
