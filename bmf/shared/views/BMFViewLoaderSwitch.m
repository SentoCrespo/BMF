//
//  BMFViewLoaderSwitch.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 16/07/14.
//
//

#import "BMFViewLoaderSwitch.h"

#import "BMF.h"

#import <ReactiveCocoa/RACEXTScope.h>

@implementation BMFViewLoaderSwitch

- (instancetype) initWithLoaderView:(BMFIXView<BMFLoaderViewProtocol> *) loaderView view:(BMFIXView *) view {
	BMFAssertReturnNil(loaderView);
	BMFAssertReturnNil(view);

    self = [super init];
    if (self) {
        _loaderView = loaderView;
		_view = view;
		
		@weakify(self);
		self.loaderView.progress.changedBlock = ^(BMFProgress *progress) {
			dispatch_async(dispatch_get_main_queue(), ^{
				@strongify(self);
				
				BOOL running = progress.running;
				self.loaderView.hidden = !running;
				self.view.hidden = running;				
			});
		};
		
//		RACSignal *runningSignal = RACObserve(self, loaderView.progress.running);
//		RAC(self.loaderView,hidden) = [[runningSignal not] map:^id(id value) {
//			DDLogDebug(@"loader view hidden signal %@",value);
//			return value;
//		}];
//		RAC(self.view,hidden) = [runningSignal map:^id(id value) {
//			DDLogDebug(@"view hidden signal %@",value);
//			return value;
//		}];

//		[runningSignal subscribeNext:^(id x) {
//			DDLogDebug(@"Loader running changed");
//		}];
    }
    return self;
}

- (void) setLoaderView:(BMFIXView<BMFLoaderViewProtocol> *)loaderView {
	BMFAssertReturn(loaderView);
	_loaderView = loaderView;
}

- (void) setView:(BMFIXView *)view {
	BMFAssertReturn(view);
	_view = view;
}

#pragma mark BMFLoaderViewProtocol

- (void) setMessage:(NSString *)message {
	self.loaderView.message = message;
}

- (NSString *) message {
	return self.loaderView.message;
}

- (void) setProgress:(BMFProgress *)progress {
	self.loaderView.progress = progress;
}

- (BMFProgress *) progress {
	return self.loaderView.progress;
}

- (void) setReloadActionBlock:(BMFActionBlock)reloadActionBlock {
	self.loaderView.reloadActionBlock = reloadActionBlock;
}

- (BMFActionBlock) reloadActionBlock {
	return self.loaderView.reloadActionBlock;
}

#if TARGET_OS_IPHONE
- (void) addToViewController:(UIViewController *) vc {
	BMFAssertReturn(self.view.superview);
	
	[self.view.superview addSubview:self.loaderView];
	[self.view.superview sendSubviewToBack:self.loaderView];
	[BMFAutoLayoutUtils equalCenters:@[ self.view, self.loaderView ]];
}

- (void) removeFromViewController:(UIViewController *)vc {
	[self.loaderView removeFromSuperview];
	self.view.hidden = NO;
}
#endif

@end
