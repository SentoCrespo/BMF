//
//  BMFM13ProgressHUD.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 3/2/15.
//
//

#import "BMFM13ProgressHUD.h"

#import "BMF.h"
#import <M13ProgressSuite/M13ProgressHUD.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface BMFM13ProgressHUD()

@property (nonatomic, strong) M13ProgressHUD *progressHUD;

@end

@implementation BMFM13ProgressHUD

- (instancetype) initWithHUD:(M13ProgressHUD *)progressHUD size:(CGSize)size {
	BMFAssertReturnNil(progressHUD);
	self = [super init];
	if (self) {
		_progressHUD = progressHUD;
		_progressHUD.progressViewSize = size;
	}
	return self;
}

- (void) addToViewController:(UIViewController *)vc {
	[vc.view addSubview:self.progressHUD];
	[BMFAutoLayoutUtils centerView:self.progressHUD inParent:vc.view];
	self.progressHUD.animationPoint = vc.view.center;
}

- (void) updateRunning: (BOOL) running {
	if (running) {
		[self.progressHUD performAction:M13ProgressViewActionNone animated:NO];
		[self.progressHUD show:YES];
	}
	else {
		if (self.progress.fractionCompleted==1) {
			if (self.progress.failedError) {
				[self.progressHUD performAction:M13ProgressViewActionFailure animated:YES];
			}
			else {
				[self.progressHUD performAction:M13ProgressViewActionSuccess animated:YES];
			}
		}
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.progressHUD.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.progressHUD hide:YES];
			[self.progressHUD performAction:M13ProgressViewActionNone animated:YES];
		});
	}
}

- (void) updateProgress:(CGFloat) progress {
	[self.progressHUD setProgress:progress animated:YES];
}

@end
