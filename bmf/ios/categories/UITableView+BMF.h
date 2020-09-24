//
//  UITableView+BMF.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 29/01/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMFTypes.h"

@interface UITableView (BMF)

- (void) BMF_deselectAllRowsAnimated:(BOOL)animated;

/// This uses the current rowHeight as the estimated row height
- (void) BMF_automaticCellHeights;
- (void) BMF_automaticCellHeights:(CGFloat) estimatedHeight;

- (void) BMF_showSeparatorsForEmptyCells;
- (void) BMF_hideSeparatorsForEmptyCells;

/// Useful if your delegate is a proxy and its respondToSelector results can vary
- (void) BMF_updateDelegate:(id)delegate;

- (BOOL) BMF_isEmpty;

- (BOOL) BMF_indexPathValid:(NSIndexPath *) indexPath;

- (void) BMF_reloadCellsAtIndexPaths:(NSArray *) indexPaths withAnimation:(UITableViewRowAnimation) updateAnimation;

/// Enumerates all the valid index paths and calls the block for each one of them
- (void) BMF_enumerateIndexPaths:(BMFObjectActionBlock) actionBlock;

- (NSIndexPath *) BMF_predecessorOf:(NSIndexPath *) indexPath wrap:(BOOL)wrap;
- (NSIndexPath *) BMF_sucessorOf:(NSIndexPath *) indexPath wrap:(BOOL)wrap;

- (void) BMF_scrollToBottom:(BOOL)animated;

@end
