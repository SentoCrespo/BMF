//
//  BMFPopNavigationControllerBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/1/15.
//
//

#import "BMFPopNavigationControllerBehavior.h"

#import "BMF.h"

@implementation BMFPopNavigationControllerBehavior

- (IBAction)popViewController:(id)sender {
	if (!self.enabled) return;
	BMFAssertReturn(self.object.navigationController);
	
	[self.object.navigationController popViewControllerAnimated:self.animated];
}

- (IBAction)popToRootViewController:(id)sender {
	if (!self.enabled) return;
	BMFAssertReturn(self.object.navigationController);

	[self.object.navigationController popToRootViewControllerAnimated:self.animated];
}


@end
