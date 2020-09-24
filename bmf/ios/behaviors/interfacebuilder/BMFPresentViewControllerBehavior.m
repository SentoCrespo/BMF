//
//  BMFPresentViewControllerBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 22/1/15.
//
//

#import "BMFPresentViewControllerBehavior.h"

#import "BMF.h"

@interface BMFPresentViewControllerBehavior()

@property (nonatomic, assign) BOOL presenting;

@end

@implementation BMFPresentViewControllerBehavior

- (IBAction)presentViewController:(id)sender {
	if (!self.enabled) return;
	if (self.presenting) return;
	
	BMFAssertReturn(self.className.length>0 || self.segueName.length>0);

	self.presenting = YES;
	
	if (self.className.length>0) {
		UIViewController *vc = [NSClassFromString(self.className) new];

		[self.object presentViewController:vc animated:self.animated completion:^{
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}];
	}
	else {
		[self.object performSegueWithIdentifier:self.segueName sender:sender];
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

- (void) viewDidDisappear:(BOOL)animated {
	self.presenting = NO;
}

@end
