//
//  BMFRotateImageLoaderView.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 29/1/15.
//
//

#import "BMFRotatingLoaderView.h"

#import "BMFAutoLayoutUtils.h"

@interface BMFRotatingLoaderView()

@property (nonatomic, assign) BOOL loading;

@end

@implementation BMFRotatingLoaderView

#pragma mark View cycle

- (void) performInit {
	[super performInit];
	
	self.progress = [BMFProgress new];
	[self performHideLoading:NO];
	
	@weakify(self);
	[[RACObserve(self, progress.running) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber *loading) {
		@strongify(self);
		if (loading.boolValue) {
			[self showLoading];
		}
		else {
			[self hideLoading];
		}
	}];
}

- (void) showLoading {
	if (self.loading) return;
	
	if (self.rotationDuration<=0) self.rotationDuration = 0.5;

	self.loading = YES;
	
	[UIView animateWithDuration:0.2 animations:^{
		self.alpha = 1;
	} completion:^(BOOL finished) {

		CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
		rotationAnimation.toValue = @(M_PI * 2.0);
		rotationAnimation.duration = self.rotationDuration;
//		rotationAnimation.cumulative = YES;
		rotationAnimation.repeatCount = HUGE_VALF;
		
		[self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
		
	}];
}

- (void) spinWithOptions: (UIViewAnimationOptions) options {
	[UIView animateWithDuration:self.rotationDuration/4 delay:0 options:options animations:^{
		self.transform =  CGAffineTransformRotate(self.transform, M_PI_2);
	} completion:^(BOOL animationFinished) {
		if (animationFinished) {
			if (self.loading) {
				[self spinWithOptions:UIViewAnimationCurveLinear | UIViewAnimationOptionBeginFromCurrentState];
			}
			else if (options != UIViewAnimationOptionCurveEaseOut) {
				[self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
			}
		}
	}];
}

- (void) hideLoading {
	if (!self.loading) return;
	
	[self performHideLoading:YES];
}

- (void) performHideLoading:(BOOL)animated {
	[self.layer removeAllAnimations];
	if (animated) {
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//			self.transform = CGAffineTransformIdentity;
			self.alpha = 0;
		} completion:^(BOOL animationFinished) {
		}];
	}
	else {
		self.transform = CGAffineTransformIdentity;
		self.alpha = 0;
	}
	self.loading = NO;
}

- (void) addToViewController:(UIViewController *) vc {
	[vc.view addSubview:self];
	[vc.view bringSubviewToFront:self];
	
	[BMFAutoLayoutUtils centerView:self inParent:vc.view];
	
	vc.view.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void) removeFromViewController:(UIViewController *)vc {
	[self removeFromSuperview];
}

@end
