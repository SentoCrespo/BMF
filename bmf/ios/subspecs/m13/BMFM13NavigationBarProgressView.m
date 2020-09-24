//
//  BMFM13NavigationBarProgressView.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 28/05/14.
//
//

#import "BMFM13NavigationBarProgressView.h"

#import <M13ProgressSuite/UINavigationController+M13ProgressViewBar.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "BMF.h"

@interface BMFM13NavigationBarProgressView()

@property (nonatomic, weak) UIViewController *viewController;

@end

@implementation BMFM13NavigationBarProgressView

- (void) addToViewController:(UIViewController *) vc {
	self.viewController = vc;
}

- (void) updateRunning: (BOOL) running {
	if (running) {
		DDLogDebug(@"Hide progress");
		[self.viewController.navigationController setProgress:0 animated:NO];
		[self.viewController.navigationController showProgress];
	}
	else {
		if (self.progress.fractionCompleted==1) {
			if (self.progress.failedError) {
//				if (self.viewController.navigationController.isShowingProgressBar) {
					DDLogDebug(@"Cancel progress");
					[self.viewController.navigationController cancelProgress];
//				}
			}
			else {
				if (self.viewController.navigationController.isShowingProgressBar) {
					DDLogDebug(@"Finish progress");
					[self.viewController.navigationController finishProgress];
				}
			}
		}
		else {
			[self.viewController.navigationController cancelProgress];
		}
	}
}

- (void) updateProgress:(CGFloat) progress {
	if (self.progress.running) [self.viewController.navigationController setProgress:progress animated:YES];
}

@end
