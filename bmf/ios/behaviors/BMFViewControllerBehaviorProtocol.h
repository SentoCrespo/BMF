//
//  BMFViewControllerBehaviorProtocol.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 03/02/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFAspectProtocol.h"

@protocol BMFBehaviorsViewControllerProtocol;

@protocol BMFViewControllerBehaviorProtocol <BMFAspectProtocol>

@property (nonatomic, weak) IBOutlet UIViewController<BMFBehaviorsViewControllerProtocol> *owner;

// Object is the same as owner, but setting the owner adds self as a behavior of the object
@property (nonatomic, weak) UIViewController<BMFBehaviorsViewControllerProtocol> *object;

@optional

/// Implement this if you want to respond to a selector only for certain arguments. Useful for delegate methods that return a value, for example
- (BOOL) respondsToSelector:(SEL)selector withArguments:(NSArray *) arguments;

#pragma mark View
- (void) viewDidLoad;

#pragma mark Memory warnings
- (void) didReceiveMemoryWarning;

#pragma mark View events
- (void) viewWillAppear: (BOOL) animated;
- (void) viewDidAppear: (BOOL) animated;
- (void) viewWillDisappear: (BOOL) animated;
- (void) viewDidDisappear: (BOOL) animated;
- (void) viewWillLayoutSubviews;
- (void) viewDidLayoutSubviews;

#pragma mark Segues
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender NS_AVAILABLE_IOS(5_0);
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender NS_AVAILABLE_IOS(6_0);
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender NS_AVAILABLE_IOS(5_0);
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator;

#pragma mark View rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;

#pragma mark Size class
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator;

#pragma mark Containment events
- (void)willMoveToParentViewController:(UIViewController *)parent;
- (void)didMoveToParentViewController:(UIViewController *)parent;

#pragma mark Edit mode
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

#pragma mark Restoration
- (void)applicationFinishedRestoringState;


#pragma mark Child view controllers
- (void)addChildViewController:(UIViewController *)childController;
- (void)removeFromParentViewController;
- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
- (void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated;
- (void)endAppearanceTransition;

- (void) updateViewConstraints;


@end
