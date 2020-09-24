//
//  BMFViewLoader.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/3/15.
//
//

#import "BMFViewLoader.h"

@implementation BMFViewLoader

- (instancetype)init {
	self = [super init];
	if (self) {
		_progress = [BMFProgress new];
		
		@weakify(self);
		[[[RACObserve(self, progress.running) throttle:0.02] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber *loading) {
			@strongify(self);
			UIActivityIndicatorView *loaderView = [UIActivityIndicatorView BMF_cast:self.view];
			if (loaderView) {
				if (loading.boolValue) {
					DDLogInfo(@"Start Animating loader");
					[loaderView startAnimating];
				}
				else {
					DDLogInfo(@"Stop Animating loader");
					[loaderView stopAnimating];
				}
			}
		}];
		
		[[[RACObserve(self, progress.fractionCompleted) throttle:0.02] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber *completed) {
			@strongify(self);
			UIProgressView *progressView = [UIProgressView BMF_cast:self.view];
			if (progressView) {
				progressView.progress = completed.floatValue;
			}
		}];
	}
	return self;
}

- (void) setView:(UIView *)view {
	BMFAssertReturn([view isKindOfClass:[UIProgressView class]] || [view isKindOfClass:[UIActivityIndicatorView class]]);
	_view = view;
}

- (void) addToViewController:(UIViewController *) vc { }
- (void) removeFromViewController:(UIViewController *)vc {}

@end
