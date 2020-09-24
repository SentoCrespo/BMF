//
//  UICollectionView+BMF.h
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 03/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMFViewRegisterProtocol.h"
#import "BMFTypes.h"

@interface UICollectionView (BMF)

/// Useful if your delegate is a proxy and its respondToSelector results can vary
- (void) BMF_updateDelegate:(id)delegate;

- (BOOL) BMF_isEmpty;

- (BOOL) BMF_indexPathValid:(NSIndexPath *) indexPath;

- (void) BMF_reloadCellsAtIndexPaths:(NSArray *) indexPaths;

- (void) BMF_enumerateIndexPaths:(BMFObjectActionBlock) actionBlock;

- (void) BMF_invalidateLayout;

@end
