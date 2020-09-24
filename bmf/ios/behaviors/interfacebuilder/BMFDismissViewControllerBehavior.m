//
//  BMFDismissViewControllerBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 16/3/15.
//
//

#import "BMFDismissViewControllerBehavior.h"

#import "BMF.h"

@implementation BMFDismissViewControllerBehavior

- (IBAction)dismiss:(id)sender {
	if (!self.enabled) return;
	BMFAssertReturn([self.object isKindOfClass:[UIViewController class]]);
	
	[self.object dismissViewControllerAnimated:self.animated completion:^{
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}];
}

@end
