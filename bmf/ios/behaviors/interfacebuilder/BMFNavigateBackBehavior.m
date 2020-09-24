//
//  BMFNavigateBackBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/12/14.
//
//

#import "BMFNavigateBackBehavior.h"

#import "BMF.h"

@implementation BMFNavigateBackBehavior

- (void) awakeFromNib {
	self.animated = YES;
}

- (IBAction)navigate:(id)sender {
	if (!self.isEnabled) return;

	BMFAssertReturn(self.object);
	
	if (self.object.navigationController) {
		[self.object.navigationController popViewControllerAnimated:self.animated];
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
	else {
		[self.object dismissViewControllerAnimated:self.animated completion:^{
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}];
	}
}

@end
