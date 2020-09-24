//
//  BMFDelayActionBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 4/12/14.
//
//

#import "BMFDelayActionBehavior.h"

@implementation BMFDelayActionBehavior

- (IBAction)run:(id)sender {
	if (!self.enabled) return;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		if (!self.object) return;
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	});
}

@end
