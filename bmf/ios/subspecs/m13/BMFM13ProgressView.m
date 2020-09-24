//
//  BMFM13ProgressView.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 27/05/14.
//
//

#import "BMFM13ProgressView.h"

#import "BMF.h"
#import <M13ProgressSuite/M13ProgressView.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface BMFM13ProgressView()

@property (nonatomic, strong) M13ProgressView *progressView;
@property (nonatomic, assign) CGSize size;

@end

@implementation BMFM13ProgressView

- (instancetype) initWithView:(M13ProgressView *) progressView size:(CGSize) size {
    self = [super init];
    if (self) {
        _progressView = progressView;
		_size = size;
	}
    return self;
}

- (void) addToViewController:(UIViewController *) vc {
	[vc.view addSubview:self.progressView];
	[BMFAutoLayoutUtils centerView:self.progressView inParent:vc.view];
	[BMFAutoLayoutUtils sizeEqual:self.progressView constant:self.size];
	self.progressView.alpha = 0;
}

- (void) updateRunning: (BOOL) running {
	if (running) {
		[self.progressView performAction:M13ProgressViewActionNone animated:NO];
		[self.progressView setProgress:self.progress.fractionCompleted animated:NO];
		self.progressView.alpha = 1;
	}
	else {
		if (self.progress.fractionCompleted==1) {
			if (self.progress.failedError) {
				[self.progressView performAction:M13ProgressViewActionFailure animated:YES];
			}
			else {
				[self.progressView performAction:M13ProgressViewActionSuccess animated:YES];
			}
		}
		
		[UIView animateWithDuration:0.3 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
			self.progressView.alpha = 0;
		} completion:^(BOOL finished){
			[self.progressView performAction:M13ProgressViewActionNone animated:NO];
		}];
	}
}

- (void) updateProgress:(CGFloat) progress {
	DDLogInfo(@"Update progress: %f",progress);
	[self.progressView setProgress:progress animated:YES];
}

@end
