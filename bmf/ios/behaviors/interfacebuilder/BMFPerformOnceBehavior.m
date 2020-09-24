//
//  BMFPerformOnceBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 4/2/15.
//
//

#import "BMFPerformOnceBehavior.h"

#import "BMF.h"

@implementation BMFPerformOnceBehavior

- (IBAction) performOnce:(id)sender {
	[BMFUtils performOnce:^{
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	} taskId:self.taskId];
}

- (IBAction) performOncePerVersion:(id)sender {
	[BMFUtils performOncePerVersion:^{
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	} taskId:self.taskId];
}

- (IBAction) performOncePerBuild:(id)sender {
	[BMFUtils performOncePerBuild:^{
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	} taskId:self.taskId];
}

- (IBAction) performOncePerLaunch:(id)sender {
	[BMFUtils performOncePerLaunch:^{
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}];
}

- (IBAction) reset:(id)sender {
	[BMFUtils resetTaskId:self.taskId];
}

@end
