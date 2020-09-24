//
//  BMFViewControllerContextBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/07/14.
//
//

#import "BMFViewControllerContextBehavior.h"

#import "BMF.h"

@implementation BMFViewControllerContextBehavior

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	UIViewController *destinationVC = [BMFUtils extractDetailViewController:segue.destinationViewController];
	[self applyTo:destinationVC];
}

- (void) applyTo:(UIViewController *) destinationVC {
	
	BMFAssertReturn([self.object isKindOfClass:[UIViewController class]]);
	
	BMFViewControllerContext *context = [self newContextWithViewController:self.object];
	
	if (self.prepareBlock) self.prepareBlock(context);
		
	[context apply:destinationVC];
	
	if (self.applyBlock) self.applyBlock(context,destinationVC);
}

- (void) applyToViewControllers:(NSArray *) viewControllers {
	for (UIViewController *vc in viewControllers) {
		[self applyTo:vc];
	}
}

- (BMFViewControllerContext *) newContextWithViewController:(UIViewController *) viewController {
	return [BMFViewControllerContext contextFromViewController:viewController];
}

@end
