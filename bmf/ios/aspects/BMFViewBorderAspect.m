//
//  BMFButtonBorderAspect.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 03/07/14.
//
//

#import "BMFViewBorderAspect.h"

#import "BMF.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BMFViewBorderAspect()

@property (nonatomic, weak) UIView *view;

@end

@implementation BMFViewBorderAspect {
	RACDisposable *tintColorSubscription;
}

- (void) setView:(UIView *)view {
	self.object = view;
}

- (UIView *) view {
	return self.object;
}

- (instancetype) init {
	self = [super init];
	if (self) {
		_borderWidth = 1;

		@weakify(self);
		[RACObserve(self, view.tintColor) subscribeNext:^(id x) {
			@strongify(self);
			[self p_updateView];
		}];
		
		[RACObserve(self, object) subscribeNext:^(id x) {
			[tintColorSubscription dispose], tintColorSubscription = nil;
			tintColorSubscription = [[x rac_signalForSelector:@selector(tintColorDidChange)] subscribeNext:^(id x) {
				@strongify(self);
				[self p_updateView];
			}];
		}];
	}
	return self;
}

- (void) dealloc {
	[tintColorSubscription dispose], tintColorSubscription = nil;
}

- (void) setObject:(id)object {
	
	BMFAssertReturn([object isKindOfClass:[UIView class]]);
	
	[super setObject:object];
	
	[self p_updateView];
}

- (void) setBorderWidth:(CGFloat)borderWidth {
	_borderWidth = borderWidth;

	[self p_updateView];
}

- (void) setBorderColor:(UIColor *)borderColor {
	_borderColor = borderColor;

	[self p_updateView];
}

- (void) p_updateView {
	UIView *view = self.object;
	view.layer.borderWidth = self.borderWidth;
	
	if (self.borderColor) view.layer.borderColor = self.borderColor.CGColor;
	else view.layer.borderColor = view.tintColor.CGColor;
}

@end
