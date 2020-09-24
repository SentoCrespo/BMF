//
//  BMFButtonBorderAspect.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 03/07/14.
//
//

#import "BMFAspect.h"

@interface BMFViewBorderAspect : BMFAspect

/// 1 by default
@property (nonatomic, assign) CGFloat borderWidth;

/// nil by default. If it's nil the button tintColor will be used
@property (nonatomic, strong) UIColor *borderColor;

@end
