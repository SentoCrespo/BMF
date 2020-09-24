//
//  TNViewController.m
//  DataSources
//
//  Created by José Manuel Sánchez on 28/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFViewController.h"

#import "BMF.h"
#import "BMFBlockActivity.h"

@interface BMFViewController ()
//	@property (nonatomic, assign) BOOL isVisible;
	@property (nonatomic, strong) NSMutableDictionary *segueActionsDic;
@end

@implementation BMFViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self performInit];
    }
    return self;
}

- (id)initWithParameters:(NSDictionary*) parameters nibName:(NSString *)nibNameOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nil];
	if (self) {
		[self performInit];
	}
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self performInit];
	}
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self performInit];
    }
    return self;
}

/// Teplate method
- (void) performInit {
	self.navigationDirection = BMFViewControllerNavigationDirectionForward;

	self.BMF_proxy = [BMFArrayProxy new];
	
	self.segueActionsDic = [NSMutableDictionary dictionary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
	DDLogDebug(@"view controller did receive memory warning");
	
	if ([self.BMF_proxy respondsToSelector:@selector(didReceiveMemoryWarning)]) [self.BMF_proxy didReceiveMemoryWarning];
	
	self.segueActionsDic = nil;
}

#pragma mark Accessors

- (void) setLoaderView:(id<BMFLoaderViewProtocol>)loaderView {
	BMFAssertReturn(!_loaderView || [_loaderView conformsToProtocol:@protocol(BMFLoaderViewProtocol)]);
	
	if (loaderView==_loaderView) return;
	
	[_loaderView removeFromViewController:self];
	
	_loaderView = loaderView;
	
	if ([self isViewLoaded])  {
		[self addLoaderView];
	}
}

- (void) addLoaderView {
	if (!_loaderView) return;
	
	if ([_loaderView isKindOfClass:[UIView class]] && [self.view BMF_hasDescendant:(id)_loaderView]) return;
	
	if ([_loaderView conformsToProtocol:@protocol(BMFLoaderViewProtocol) ]) [_loaderView addToViewController:self];
}

- (NSArray *) behaviors {
	return [NSArray arrayWithArray:[self.BMF_proxy.destinationObjects allObjects]];
}

- (void) addBehavior: (id<BMFViewControllerBehaviorProtocol>) behavior {

	[self BMF_addAspect:behavior];
	
	if (self.isViewLoaded) {
		if ([behavior respondsToSelector:@selector(viewDidLoad)]) {
			[behavior viewDidLoad];
		}
	}
}

- (void) removeBehavior: (id<BMFViewControllerBehaviorProtocol>) behavior {
	[self BMF_removeAspect:behavior];
}

- (void) removeAllBehaviors {
	[self BMF_removeAllAspects];
}

- (void) runTask:(id<BMFTaskProtocol>) task completion:(BMFCompletionBlock) completionBlock {
	[self.loaderView.progress addChild:task.progress];
	[task run:completionBlock];
}

- (void) startTask:(id<BMFTaskProtocol>) task completion:(BMFCompletionBlock) completionBlock {
	[self runTask:task completion:completionBlock];
}

#pragma mark View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
//	self.loaderView = [[BMFBase sharedInstance].factory generalLoaderView:self];
	
	UIView *view = [UIView BMF_cast:self.loaderView];
	if (!view.superview) [self addLoaderView];
	
	if ([self.BMF_proxy respondsToSelector:@selector(viewDidLoad)]) [self.BMF_proxy viewDidLoad];
	
	if (self.didLoadBlock) self.didLoadBlock(self);
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	UIView *view = [UIView BMF_cast:self.loaderView];
	if (view) [view.superview bringSubviewToFront:view];
	
	if ([self.BMF_proxy respondsToSelector:@selector(viewWillAppear:)]) [self.BMF_proxy viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	self.isVisible = YES;
	
	if (self.didAppearBlock) self.didAppearBlock(self);
	
	if ([self.BMF_proxy respondsToSelector:@selector(viewDidAppear:)]) [self.BMF_proxy viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	self.isVisible = NO;
	
	if ([self isMovingToParentViewController] || [self isBeingDismissed]) {
		self.navigationDirection = BMFViewControllerNavigationDirectionBackward;
	}
	else {
        if (self.navigationController && [self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
            self.navigationDirection = BMFViewControllerNavigationDirectionBackward;
        }
        else {
            self.navigationDirection = BMFViewControllerNavigationDirectionForward;
        }
	}
	
	if ([self.BMF_proxy respondsToSelector:@selector(viewWillDisappear:)]) [self.BMF_proxy viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	if ([self.BMF_proxy respondsToSelector:@selector(viewDidDisappear:)]) [self.BMF_proxy viewDidDisappear:animated];
}


#pragma mark View events
	
- (void) viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
		
	if ([self.BMF_proxy respondsToSelector:@selector(viewWillLayoutSubviews)]) [self.BMF_proxy viewWillLayoutSubviews];
}
	
- (void) viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	if ([self.BMF_proxy respondsToSelector:@selector(viewDidLayoutSubviews)]) [self.BMF_proxy viewDidLayoutSubviews];
}
	

#pragma mark View rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	if ([self.BMF_proxy respondsToSelector:@selector(willRotateToInterfaceOrientation:duration:)]) [self.BMF_proxy willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
	
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
	
	if ([self.BMF_proxy respondsToSelector:@selector(willAnimateRotationToInterfaceOrientation:duration:)]) [self.BMF_proxy willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}
	
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

	if ([self.BMF_proxy respondsToSelector:@selector(didRotateFromInterfaceOrientation:)]) [self.BMF_proxy didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

	if ([self.BMF_proxy respondsToSelector:@selector(viewWillTransitionToSize:withTransitionCoordinator:)]) [self.BMF_proxy viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
	[super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];

	if ([self.BMF_proxy respondsToSelector:@selector(willTransitionToTraitCollection:withTransitionCoordinator:)]) [self.BMF_proxy willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
}


#pragma mark Containment events
- (void)willMoveToParentViewController:(UIViewController *)parent {
	[super willMoveToParentViewController:parent];

	if ([self.BMF_proxy respondsToSelector:@selector(willMoveToParentViewController:)]) [self.BMF_proxy willMoveToParentViewController:parent];
}
	
- (void)didMoveToParentViewController:(UIViewController *)parent {
	[super didMoveToParentViewController:parent];

	if ([self.BMF_proxy respondsToSelector:@selector(didMoveToParentViewController:)]) [self.BMF_proxy didMoveToParentViewController:parent];
}
	

#pragma mark Edit mode
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];

	if ([self.BMF_proxy respondsToSelector:@selector(setEditing:animated:)]) [self.BMF_proxy setEditing:editing animated:animated];
}
	

#pragma mark Restoration
- (void)applicationFinishedRestoringState {
	[super applicationFinishedRestoringState];

	if ([self.BMF_proxy respondsToSelector:@selector(applicationFinishedRestoringState)]) [self.BMF_proxy applicationFinishedRestoringState];
}
	
#pragma mark Segues

- (void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	[super performSegueWithIdentifier:identifier sender:sender];

	if ([self.BMF_proxy respondsToSelector:@selector(performSegueWithIdentifier:sender:)]) [self.BMF_proxy performSegueWithIdentifier:identifier sender:sender];
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	BOOL shouldPerform = YES;
	if ([self.BMF_proxy respondsToSelector:@selector(shouldPerformSegueWithIdentifier:sender:)]) shouldPerform = [self.BMF_proxy shouldPerformSegueWithIdentifier:identifier sender:sender];
	
	if (!shouldPerform) return NO;
	
	return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	BMFActivity *activity = self.segueActionsDic[segue.identifier];
	if (activity) {
		activity.value = segue;
		[activity run:nil];
		[self.segueActionsDic removeObjectForKey:segue.identifier];
	}
	
	if ([self.BMF_proxy respondsToSelector:@selector(prepareForSegue:sender:)]) [self.BMF_proxy prepareForSegue:segue sender:sender];
}

- (void) performSegueWithIdentifier:(NSString *)identifier prepareBlock:(BMFSegueActionBlock) block {
	self.segueActionsDic[identifier] = [[BMFBlockActivity alloc] initWithBlock:^(id sender, id value, BMFCompletionBlock completionBlock) {
		
		if (block) block(value);
		
		if (completionBlock) completionBlock(nil,nil);
	}];
	
	[self performSegueWithIdentifier:identifier sender:self];
}

#pragma mark Child view controllers
- (void)addChildViewController:(UIViewController *)childController {
	[super addChildViewController:childController];

	if ([self.BMF_proxy respondsToSelector:@selector(addChildViewController:)]) [self.BMF_proxy addChildViewController:childController];
}
	
- (void)removeFromParentViewController {
	[super removeFromParentViewController];

	if ([self.BMF_proxy respondsToSelector:@selector(removeFromParentViewController)]) [self.BMF_proxy removeFromParentViewController];
}
	
- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
	[super transitionFromViewController:fromViewController toViewController:toViewController duration:duration
										options:options animations:animations completion:completion];

	if ([self.BMF_proxy respondsToSelector:@selector(transitionFromViewController:toViewController:duration:options:animations:completion:)]) [self.BMF_proxy transitionFromViewController:fromViewController toViewController:toViewController duration:duration options:options animations:animations completion:completion];
}

- (void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated {
	[super beginAppearanceTransition:isAppearing animated:animated];

	if ([self.BMF_proxy respondsToSelector:@selector(beginAppearanceTransition:animated:)]) [self.BMF_proxy beginAppearanceTransition:isAppearing animated:animated];
}
	
- (void)endAppearanceTransition {
	[super endAppearanceTransition];

	if ([self.BMF_proxy respondsToSelector:@selector(endAppearanceTransition)]) [self.BMF_proxy endAppearanceTransition];
}

#pragma mark Autolayout

- (void)updateViewConstraints {
	[super updateViewConstraints];

	if ([self.BMF_proxy respondsToSelector:@selector(updateViewConstraints)]) [self.BMF_proxy updateViewConstraints];
}

@end
