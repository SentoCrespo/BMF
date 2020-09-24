//
//  BMFAdjustObscuredTextFieldsBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/07/14.
//
//

#import "BMFAdjustObscuredTextFieldsBehavior.h"

#import "BMF.h"
#import "BMFKeyboardManager.h"

#import <ReactiveCocoa/RACEXTScope.h>

static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;

@interface BMFAdjustObscuredTextFieldsBehavior() <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) BOOL isChangingField;
@property (nonatomic, weak) UIView *selectedTextInputField;
@property (nonatomic, assign) BOOL active;

@end

@implementation BMFAdjustObscuredTextFieldsBehavior

- (instancetype)init {
	self = [super init];
	if (self) {
		[self prepareTextFields];
		
		@weakify(self);
		[RACObserve([BMFBase sharedInstance].keyboardManager,keyboardHeight) subscribeNext:^(NSNumber *visible) {
			@strongify(self);
			if (!self.active) return;
			if (visible.boolValue) {
				[self adjust];
			}
			else {
				[self removeAdjustments];
			}
		}];
		
	}
	return self;

}

//- (void) setObject:(UIViewController<BMFBehaviorsViewControllerProtocol> *)object {
//	[super setObject:object];
//	
//	self.origin = object.view.frame.origin;
//	[self prepareTextFields];
//}

- (void) viewDidLoad {
	self.origin = self.object.view.frame.origin;
	[self prepareTextFields];
}

- (void) viewWillAppear:(BOOL)animated {
	self.active = YES;
}

- (void) viewWillDisappear:(BOOL)animated {
	self.active = NO;
}

- (void) prepareTextFields {
	if (!self.enabled) return;
	if (!self.object) return;
	
	for (UITextField *tf in _textFields) {
		if (tf) [self.object.BMF_proxy makeDelegateOf:tf withSelector:@selector(setDelegate:)];
	}
}

- (void) adjust {
	if (!self.enabled) return;
	
	UIViewController *viewController = [self viewControllerToAdjust];
	
	CGRect textFieldRect = [viewController.view.window convertRect:self.selectedTextInputField.bounds fromView:self.selectedTextInputField];
    CGRect viewRect = [viewController.view.window convertRect:viewController.view.bounds fromView:viewController.view];
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
	CGFloat numerator =	midline - viewRect.origin.y	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
	CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
	CGFloat heightFraction = numerator / denominator;
	
	if (heightFraction < 0.0) {
		heightFraction = 0.0;
	}
	else if (heightFraction > 1.0) {
		heightFraction = 1.0;
	}
	
	BMFKeyboardManager *keyboardManager = [BMFBase sharedInstance].keyboardManager;
	CGFloat animatedDistance = keyboardManager.keyboardHeight*heightFraction;
		
	CGRect viewFrame = viewController.view.frame;
	viewFrame.origin = self.origin;
	viewFrame.origin.y -= animatedDistance;
    
	[UIView animateWithDuration:keyboardManager.animationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		viewController.view.frame = viewFrame;
	} completion:nil];
}


- (void) removeAdjustments {
	if (!self.enabled) return;
//	if (self.isChangingField) return;

	
	UIViewController *viewController = [self viewControllerToAdjust];
	
	CGRect frame = viewController.view.frame;
	frame.origin = self.origin;
	viewController.view.frame = frame;
}

- (UIViewController *) viewControllerToAdjust {
	if (!self.object) return nil;
	
	BMFAssertReturnNil([self.object isKindOfClass:[UIViewController class]]);
	
	UIViewController *vc = self.object;
	while (vc.parentViewController) {
		vc = vc.parentViewController;
	};
	
	return vc;
}

#pragma mark UITextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField {
	self.isChangingField = YES;
	self.selectedTextInputField = textField;

	[self adjust];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
	self.isChangingField = NO;
	if (self.selectedTextInputField==textField) self.selectedTextInputField = nil;
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
	self.isChangingField = YES;
	self.selectedTextInputField = textView;
	[self adjust];
	
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	self.isChangingField = NO;
	if (self.selectedTextInputField==textView) self.selectedTextInputField = nil;
}

@end
