//
//  BMFBackgroundTapBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/2/15.
//
//

#import "BMFBackgroundTapBehavior.h"

@interface BMFBackgroundTapBehavior() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation BMFBackgroundTapBehavior

- (void) viewDidLoad {
	if (!self.enabled) return;
	self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
	self.tapRecognizer.delegate = self;
	[self.object.view addGestureRecognizer:self.tapRecognizer];
}

- (void) backgroundTap:(UIGestureRecognizer *) recognizer {
	if (!self.enabled) return;
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	if (touch.view != self.object.view) return NO;
	return YES;
}

@end
