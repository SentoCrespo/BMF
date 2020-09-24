//
//  BMFViewLoaderSwitchBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/07/14.
//
//

#import "BMFViewLoaderSwitchBehavior.h"

#import "BMF.h"

@implementation BMFViewLoaderSwitchBehavior

- (void) performInit {
	[super performInit];
	
	RACSignal *runningSignal = RACObserve(self, loaderView.progress.running);
	
	RAC(self.loaderView,hidden) = [runningSignal not];
	RAC(self.view,hidden) = runningSignal;
}

- (void) setLoaderView:(UIView<BMFLoaderViewProtocol> *)loaderView {
	BMFAssertReturn(loaderView);
	_loaderView = loaderView;
}

- (void) setView:(UIView *)view {
	BMFAssertReturn(view);
	_view = view;
}



@end
