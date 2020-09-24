//
//  BMFDisplayItemBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/1/15.
//
//

#import "BMFViewControllerBehavior.h"

#import "BMFTypes.h"

@interface BMFDisplayItemBehavior : BMFViewControllerBehavior <UITableViewDelegate, UICollectionViewDelegate>

/// Template method. Should be implemented by subclasses
- (void) willDisplay:(id) item atIndexPath:(NSIndexPath *) indexPath view:(UIView *)view containerView:(UIView *) containerView;

/// Template method. Should be implemented by subclasses
- (void) didDisplay:(id) item atIndexPath:(NSIndexPath *) indexPath view:(UIView *)view containerView:(UIView *) containerView;

@end
