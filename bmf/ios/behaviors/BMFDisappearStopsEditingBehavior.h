//
//  BMFDisappearStopsEditingBehavior.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFViewControllerBehavior.h"

__deprecated

/// Deprecated class. Use a disappear trigger behavior combined with a stop editing behavior instead
@interface BMFDisappearStopsEditingBehavior : BMFViewControllerBehavior

@property (nonatomic, assign) BOOL forceStopEditing; // NO by default

@end
