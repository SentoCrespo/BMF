//
//  BMFScrollStopsEditingBehavior.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFScrollViewViewControllerBehavior.h"

__deprecated

/// Deprecated. Use a scrolloffsetbehavior combined with a stop editing behavior instead
@interface BMFScrollStopsEditingBehavior : BMFScrollViewViewControllerBehavior

// 60 by default
@property (nonatomic, assign) CGFloat offsetToStopEditing;

/// YES by default
@property (nonatomic, assign) BOOL forceStopEditing;

@end
