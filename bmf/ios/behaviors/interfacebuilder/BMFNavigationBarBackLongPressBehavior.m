//
//  BMFNavigationBarLongPressBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/3/15.
//
//

#import "BMFNavigationBarBackLongPressBehavior.h"

#import "BMF.h"

@interface BMFNavigationBarBackLongPressBehavior ()

@property (nonatomic) UILongPressGestureRecognizer *lpGestureRecognizer;

@end

@implementation BMFNavigationBarBackLongPressBehavior

- (void) viewDidLoad {
	if (!self.enabled) return;
	[self p_installRecognizer];
}

- (void) viewWillAppear:(BOOL)animated {
	if (!self.enabled) return;
	[self p_installRecognizer];
}

- (IBAction)longPress:(UIGestureRecognizer *)recognizer {
	if (!self.enabled) return;
	
	CGPoint location = [recognizer locationInView:self.object.navigationController.navigationBar];
	if (location.x>self.object.navigationController.navigationBar.bounds.size.width/3) {
		return;
	}
	
	if (self.actionBlock) self.actionBlock(self);
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (BOOL) p_installRecognizer {
	if (!self.object.navigationController.navigationBar) return NO;
	if (self.lpGestureRecognizer) return YES;
	self.lpGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
	if (_minimumPressDuration>0) self.lpGestureRecognizer.minimumPressDuration = self.minimumPressDuration;
	[self.object.navigationController.navigationBar addGestureRecognizer:self.lpGestureRecognizer];
	return YES;
}

@end
