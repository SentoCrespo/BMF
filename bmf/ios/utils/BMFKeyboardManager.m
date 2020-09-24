//
//  BMFKeyboardManager.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 04/02/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFKeyboardManager.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BMFTypes.h"

@interface BMFKeyboardManager()

@property (nonatomic) BOOL showing;
@property (nonatomic) BOOL hiding;

@end

@implementation BMFKeyboardManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
		RACSignal *willShowSignal = [[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil];
		RACSignal *didShowSignal = [[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil];
		RACSignal *willHideSignal = [[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil];
		RACSignal *didHideSignal = [[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidHideNotification object:nil];
		
//		RACSignal *keyboardChangeSignal = [RACSignal merge:@[ willShowSignal, didShowSignal,willHideSignal, didHideSignal ]];
		RACSignal *keyboardChangeSignal = [RACSignal merge:@[ willShowSignal, willHideSignal ]];
//		RACSignal *keyboardChangeSignal = [RACSignal combineLatest:@[ willShowSignal, willHideSignal ]];
        
        @weakify(self);
        [willShowSignal subscribeNext:^(id x) {
           @strongify(self);
           self.showing = YES;
        }];
        
        [didShowSignal subscribeNext:^(id x) {
           @strongify(self);
           self.showing = NO;
        }];
        
        [willHideSignal subscribeNext:^(id x) {
            @strongify(self);
            self.hiding = YES;
        }];
        
        [didHideSignal subscribeNext:^(id x) {
            @strongify(self);
            self.hiding = NO;
        }];
		
		RACSignal *visibleSignal = [willShowSignal map:^id(id value) {
			return @YES;
		}];
		
		RACSignal *hiddenSignal = [willHideSignal map:^id(id value) {
			return @NO;
		}];
		
		RAC(self,keyboardVisible) = [RACSignal merge:@[visibleSignal, hiddenSignal]];
		
//		RAC(self,keyboardHeight) = [keyboardChangeSignal map:^id(id value) {
		RAC(self,keyboardHeight) = [keyboardChangeSignal map:^id(id value) {
//			id value = [tuple first];
			NSDictionary *info = [value userInfo];
			NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
			CGRect keyboardFrame = [kbFrame CGRectValue];
			
			DDLogInfo(@"keyboard frame: %@",NSStringFromCGRect(keyboardFrame));
			
			UIWindow *topWindow = [[[UIApplication sharedApplication].windows sortedArrayUsingComparator:^NSComparisonResult(UIWindow *win1, UIWindow *win2) {
				return win1.windowLevel - win2.windowLevel;
			}] firstObject];
//			UIView *topView = [[topWindow subviews] lastObject];
			
//			CGRect convertedFrame = [topView convertRect:keyboardFrame fromView:topWindow];
			CGRect convertedFrame = keyboardFrame;
			
			DDLogInfo(@"keyboard converted frame: %@",NSStringFromCGRect(convertedFrame));
			
			CGFloat height = topWindow.bounds.size.height-CGRectGetMinY(convertedFrame);
			
			if (convertedFrame.size.height>convertedFrame.size.width) {
				height = topWindow.bounds.size.width-CGRectGetMinX(convertedFrame);
			}
			
			return @(height);
				
//			if (convertedFrame.size.height>convertedFrame.size.width) return @(convertedFrame.size.width);
//			else return @(convertedFrame.size.height);
		}];
		
//		RAC(self, animationDuration) = [[keyboardChangeSignal map:^id(id value) {
		RAC(self, animationDuration) = [[keyboardChangeSignal map:^id(id value) {
//			id value = [tuple first];
			NSDictionary *info = [value userInfo];
			return [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
		}] map:^id(NSNumber *value) {
			if (!value) return @(0);
			return value;
		}];
    }
    return self;
}

@end
