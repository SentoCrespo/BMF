//
//  BMFControlRotateAspect.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/06/14.
//
//

#import "BMFAspect.h"

typedef NS_ENUM(NSUInteger, BMFControlRotateAspectMode) {
    BMFControlRotateAspectModeOnce,
    BMFControlRotateAspectModeToggle
};

@interface BMFControlRotateAspect : BMFAspect

/// 90 by default
@property (nonatomic, assign) CGFloat angle;

/// BMFControlRotateAspectModeOnce by default
@property (nonatomic, assign) BMFControlRotateAspectMode mode;

/// 0.2 by default
@property (nonatomic, assign) CGFloat animationDuration;

/// 0.95 by default
@property (nonatomic, assign) CGFloat damping;

/// 0.05 by default
@property (nonatomic, assign) CGFloat springVelocity;

@end
