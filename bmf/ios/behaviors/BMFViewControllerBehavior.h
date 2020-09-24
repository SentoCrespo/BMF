//
//  BMFViewControllerBehavior.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMFViewControllerBehaviorProtocol.h"

@interface BMFViewControllerBehavior : UIControl <BMFViewControllerBehaviorProtocol>

@property (nonatomic, weak) IBOutlet UIViewController<BMFBehaviorsViewControllerProtocol> *owner;

// Object is the same as owner, but setting the owner adds self as a behavior of the object
@property (nonatomic, weak) UIViewController<BMFBehaviorsViewControllerProtocol> *object;

@property(nonatomic,getter=isEnabled) IBInspectable BOOL enabled;

- (void) performInit __attribute((objc_requires_super));

@end
