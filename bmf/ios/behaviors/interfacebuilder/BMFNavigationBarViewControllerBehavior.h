//
//  BMFNavigationBarViewControllerBehavior.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/02/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFViewControllerBehavior.h"

@interface BMFNavigationBarViewControllerBehavior : BMFViewControllerBehavior

/// YES by default
@property (nonatomic, assign) IBInspectable BOOL navigationBarHidden;

/// YES by default
@property (nonatomic, assign) IBInspectable BOOL restoreOnDisappear;

/// YES by default
@property (nonatomic, assign) IBInspectable BOOL animated;

@end
