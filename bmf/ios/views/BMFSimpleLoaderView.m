//
//  TRNSimpleLoaderView.m
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 13/01/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import "BMFSimpleLoaderView.h"

#import "BMFAutoLayoutUtils.h"
#import "BMFCrossView.h"
#import <ReactiveCocoa/RACEXTScope.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation BMFSimpleLoaderView

- (void) performInit {
	[super performInit];
	
	self.userInteractionEnabled = NO;
	
	self.loaderView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	self.loaderView.color = [UIColor blackColor];
	self.loaderView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.loaderView setContentCompressionResistancePriority:BMFLayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	[self.loaderView setContentCompressionResistancePriority:BMFLayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	self.loaderView.hidesWhenStopped = YES;
	
	[self addSubview:self.loaderView];
	[BMFAutoLayoutUtils fill:self with:self.loaderView margin:0];
	
	self.crossHideDelay = 2.0;
	self.translatesAutoresizingMaskIntoConstraints = NO;
	
	self.progress = [BMFProgress new];
	
	@weakify(self);
	[[RACObserve(self, progress.running) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber *loading) {
		@strongify(self);
		if (loading.boolValue) {
			[self.loaderView startAnimating];
		}
		else {
			[self.loaderView stopAnimating];
		}
	}];
	

	[[RACObserve(self, progress.fractionCompleted) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber *completed) {
		@strongify(self);
		if (completed.floatValue>=self.progress.totalUnitCount && self.progress.failedError) {
#warning Show a cross and fade to a retry icon if we have a retryBlock
			BMFCrossView *crossView = [BMFCrossView new];
			[self addSubview:crossView];
			
			
			crossView.translatesAutoresizingMaskIntoConstraints = NO;
			[BMFAutoLayoutUtils fill:self with:crossView margin:0];
			
			crossView.alpha = 0;
			[UIView animateWithDuration:0.1 animations:^{
				crossView.alpha = 1;
			} completion:^(BOOL finished) {
				double delayInSeconds = self.crossHideDelay;
				dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
				dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
					[UIView animateWithDuration:0.1 animations:^{
						crossView.alpha = 0;
					} completion:^(BOOL finished) {
						[crossView removeFromSuperview];
					}];
				});
			}];
		}
	}];
}


- (void) addToViewController:(UIViewController *) vc {
	[vc.view addSubview:self];
	[vc.view bringSubviewToFront:self];
	
	[BMFAutoLayoutUtils centerView:self inParent:vc.view];
	vc.view.translatesAutoresizingMaskIntoConstraints = YES;
	
	[UIView performWithoutAnimation:^{
		[vc.view layoutSubviews];
	}];
}

- (void) removeFromViewController:(UIViewController *)vc {
	[self removeFromSuperview];
}

@end
