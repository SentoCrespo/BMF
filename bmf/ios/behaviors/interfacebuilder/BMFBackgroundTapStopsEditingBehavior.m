//
//  BMFBackgroundTapStopsEditingBehavior.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 04/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFBackgroundTapStopsEditingBehavior.h"

@interface BMFBackgroundTapStopsEditingBehavior() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation BMFBackgroundTapStopsEditingBehavior

- (void) viewDidLoad {
	if (!self.enabled) return;
	self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
	self.tapRecognizer.delegate = self;
	[self.object.view addGestureRecognizer:self.tapRecognizer];
}

- (void) backgroundTap:(UIGestureRecognizer *) recognizer {
	if (!self.enabled) return;
	[self.object.view endEditing:self.forceStopEditing];
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != self.object.view) return NO;
    return YES;
}

@end

