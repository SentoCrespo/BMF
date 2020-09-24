//
//  BMFLayoutViewAnimationBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 4/3/15.
//
//

#import "BMFLayoutViewAnimationBehavior.h"

#import "BMF.h"

@implementation BMFLayoutViewAnimationBehavior

- (void) performAnimation {
	BMFAssertReturn(self.views.count>0);
	
	for (UIView *view in self.views) {
		[view layoutIfNeeded];
	}
}

@end
