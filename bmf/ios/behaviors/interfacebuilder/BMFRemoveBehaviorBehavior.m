//
//  BMFRemoveBehaviorBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/11/14.
//
//

#import "BMFRemoveBehaviorBehavior.h"

#import "BMF.h"
#import "BMFBehaviorsViewControllerProtocol.h"

@implementation BMFRemoveBehaviorBehavior

- (IBAction) removeBehaviors:(id) sender {
	if (!self.isEnabled) return;
	
	for (BMFViewControllerBehavior *behavior in self.behaviorsToRemove) {
		[behavior.object removeBehavior:behavior];
	}
	
	self.behaviorsToRemove = nil;
}

@end
