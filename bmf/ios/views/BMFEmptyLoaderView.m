//
//  BMFEmptyLoaderView.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 22/1/15.
//
//

#import "BMFEmptyLoaderView.h"

#import "BMF.h"

@implementation BMFEmptyLoaderView

- (void) performInit {
	[super performInit];
	
	self.userInteractionEnabled = NO;
	self.progress = [BMFProgress new];
}

- (void) addToViewController:(UIViewController *) vc {
	[vc.view addSubview:self];
	[vc.view bringSubviewToFront:self];
	
	[BMFAutoLayoutUtils centerView:self inParent:vc.view];
	
	vc.view.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void) removeFromViewController:(UIViewController *)vc {
	[self removeFromSuperview];
}

@end
