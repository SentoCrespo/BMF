//
//  BMFProgressUI.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 02/06/14.
//
//

#import "BMFProgressUI.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "BMFEaseUtils.h"

@interface BMFProgressUI()

@property (nonatomic, assign) CGFloat currentProgress;
@property (nonatomic, assign) BOOL wasRunning;

@end

@implementation BMFProgressUI

- (instancetype)init
{
    self = [super init];
    if (self) {
		self.progress = [BMFProgress new];
    }
    return self;
}

- (void) setProgress:(BMFProgress *)progress {
	_progress.changedBlock = nil;
	
	_progress = progress;
	@weakify(self);
	_progress.changedBlock = ^(BMFProgress *progress) {
//		DDLogInfo(@"progress ui: %f",progress.fractionCompleted);
		BOOL isRunning = progress.running;
		@strongify(self);
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			if (self.wasRunning!=isRunning && (progress.fractionCompleted<0.01 || progress.fractionCompleted>0.99)) {
				[self updateRunning:isRunning];
				self.wasRunning = isRunning;
			}
			
			[self updateProgress:[self displayedProgressWithFractionCompleted:progress.fractionCompleted]];
		});
	};
}

- (CGFloat) displayedProgressWithFractionCompleted:(CGFloat) fractionCompleted {
	CGFloat result;
	
	// Adjust the value so it's faster when finishing
	CGFloat value = [BMFEaseUtils circularEaseIn:fractionCompleted];
	
	// Don't allow to go back
	if (value>=self.currentProgress) result = value;
	else {
		if (value==0 && self.currentProgress==1) result = value;
		else result = self.currentProgress;
	}
	
	self.currentProgress = result;

	return self.currentProgress;
}

#pragma mark Template methods

#if TARGET_OS_IPHONE

- (void) addToViewController:(UIViewController *)vc {
	BMFAbstractMethod();
}

- (void) removeFromViewController:(UIViewController *)vc {
	BMFAbstractMethod();
}

#endif

- (void) updateRunning: (BOOL) running {
	BMFAbstractMethod();
}

- (void) updateProgress:(CGFloat) progress {
	BMFAbstractMethod();
}
	
@end
