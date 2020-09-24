//
//  BMFNavigationBarLongPressBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/3/15.
//
//

#import "BMFViewControllerBehavior.h"

#import "BMFTypes.h"

@interface BMFNavigationBarBackLongPressBehavior : BMFViewControllerBehavior

/// Optional. The valuechanged event will be sent anyway
@property (nonatomic, copy, nullable) BMFActionBlock actionBlock;

@property (nonatomic) IBInspectable NSTimeInterval minimumPressDuration;

@end
