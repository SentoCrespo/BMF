//
//  BMFStopEditingBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/11/14.
//
//

#import "BMFStopEditingBehavior.h"

@implementation BMFStopEditingBehavior

- (IBAction) stopEditing:(id)sender {
	if (!self.isEnabled) return;
	
	[self.object.view endEditing:self.forceStopEditing];
}

@end
