//
//  BMFTimerActionAspect.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/07/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"
#import "BMFAspect.h"

@interface BMFTimerActionAspect : BMFAspect

/// 5 seconds by default
@property (nonatomic, assign) float interval;
@property (nonatomic, copy) BMFActionBlock actionBlock;

/// YES by default. Set to false to stop the timer behavior
@property (nonatomic, assign) BOOL enabled;

@end
