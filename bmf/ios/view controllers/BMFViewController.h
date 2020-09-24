//
//  TNViewController.h
//  DataSources
//
//  Created by José Manuel Sánchez on 28/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMFLoaderViewProtocol.h"

#import "BMFViewControllerBehaviorProtocol.h"
#import "BMFArrayProxy.h"
#import "BMFMessagesPresenterViewControllerProtocol.h"
#import "BMFTaskProtocol.h"
#import "BMFBehaviorsViewControllerProtocol.h"

enum BMFViewControllerNavigationDirection {
	BMFViewControllerNavigationDirectionForward = 1,
	BMFViewControllerNavigationDirectionBackward = 2
};

typedef void(^BMFSegueActionBlock)(UIStoryboardSegue *segue);

@interface BMFViewController : UIViewController <BMFBehaviorsViewControllerProtocol,BMFMessagesPresenterViewControllerProtocol>

@property (nonatomic, strong) id<BMFUserMessagesPresenterProtocol> messagePresenter;

/// Reference for when it's used inside a popoverViewController
@property (nonatomic, weak) UIPopoverController *BMF_popoverController;

@property (copy, nonatomic) BMFActionBlock didLoadBlock;
@property (copy, nonatomic) BMFActionBlock didAppearBlock;
@property (nonatomic, strong) IBOutlet id<BMFLoaderViewProtocol> loaderView;

@property (nonatomic, assign) BOOL isVisible;

- (void) addBehavior: (id<BMFViewControllerBehaviorProtocol>) behavior;
- (void) removeBehavior: (id<BMFViewControllerBehaviorProtocol>) behavior;
- (void) removeAllBehaviors;

- (void) runTask:(id<BMFTaskProtocol>) task completion:(BMFCompletionBlock) completionBlock;
- (void) startTask:(id<BMFTaskProtocol>) task completion:(BMFCompletionBlock) completionBlock __deprecated;

/// Allows to know the navigation direction when appearing.
@property (nonatomic, assign) enum BMFViewControllerNavigationDirection navigationDirection;

- (void) performSegueWithIdentifier:(NSString *)identifier prepareBlock:(BMFSegueActionBlock) block;

/// Template method
- (void) performInit __attribute((objc_requires_super));

@end
