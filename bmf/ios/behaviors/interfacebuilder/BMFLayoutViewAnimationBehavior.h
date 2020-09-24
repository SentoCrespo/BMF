//
//  BMFLayoutViewAnimationBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 4/3/15.
//
//

#import "BMFRunAnimationBehavior.h"

/// Use this to configure the animation of a view layout after changing the constraints
@interface BMFLayoutViewAnimationBehavior : BMFRunAnimationBehavior

@property (nonatomic) IBOutletCollection(UIView) NSArray *views;

@end
