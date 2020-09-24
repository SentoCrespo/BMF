//
//  UIViewController+BMFUtils.h
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/01/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMFTypes.h"

@class BMFPopoverController;

@interface UIViewController (BMF)

@property (nonatomic, strong) BMFPopoverController *BMF_popoverController;

- (void) BMF_addChild:(UIViewController *) detailVC addSubviewBlock:(BMFActionBlock) block;
- (void) BMF_removeFromParent;
- (void) BMF_popToRootViewController;

- (UIViewController *) BMF_viewControllerDefiningContext;
- (UIViewController *) BMF_parentViewController;

@end
