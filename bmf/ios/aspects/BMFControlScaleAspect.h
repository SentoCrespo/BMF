//
//  BMFControlScaleAspect.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/06/14.
//
//

#import "BMFAspect.h"

@interface BMFControlScaleAspect : BMFAspect

/// 0.2 by default
@property (nonatomic, assign) CGFloat animationDuration;

/// 0.95 by default
@property (nonatomic, assign) CGFloat damping;

/// 0.05 by default
@property (nonatomic, assign) CGFloat springVelocity;

@end
