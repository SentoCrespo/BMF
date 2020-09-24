//
//  BMFViewsAnimationCoordinatorBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/12/14.
//
//

#import "BMFViewsAnimationCoordinatorBehavior.h"

@interface BMFViewsAnimationCoordinatorBehavior()

@property (nonatomic, assign) NSUInteger animationsFinished;

@end

@implementation BMFViewsAnimationCoordinatorBehavior

- (void) performAnimation {
	self.animationsFinished = 0;
	
	for (UIControl<BMFViewsAnimationBehaviorProtocol> *animation in self.animations) {
		animation.views = self.views;
		[animation addTarget:self action:@selector(animationsFinished:) forControlEvents:UIControlEventValueChanged];

		[animation runAnimation:self];
	}
}

- (void) afterAnimation {
	[super afterAnimation];
}

- (IBAction)animationsFinished:(id)sender {
	self.animationsFinished++;
	if (self.animationsFinished==self.animations.count) {
		self.animationsFinished = 0;
		[self sendActionsForControlEvents:UIControlEventValueChanged];

	}
}

@end
