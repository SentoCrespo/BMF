//
//  BMFRedisplayCellsBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 13/2/15.
//
//

#import "BMFRedisplayCellsBehavior.h"
#import "BMF.h"

@implementation BMFRedisplayCellsBehavior

- (void) viewWillAppear:(BOOL)animated {
	if (!self.enabled) return;
	
	BMFAssertReturn([self.view isKindOfClass:[UITableView class]] || [self.view isKindOfClass:[UICollectionView class]]);
	[self redisplayCells];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		
	} completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		[self redisplayCells];
	}];
}

- (void) redisplayCells {
	if (!self.enabled) return;

	for (UIView *cell in [(id)self.view visibleCells]) {
		[cell setNeedsDisplay];
	}
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
