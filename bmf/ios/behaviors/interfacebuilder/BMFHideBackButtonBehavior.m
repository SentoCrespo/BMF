//
//  BMFDisableBackButtonBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/12/14.
//
//

#import "BMFHideBackButtonBehavior.h"

#import "BMF.h"

@implementation BMFHideBackButtonBehavior

- (void) viewDidLoad {
	if (!self.isEnabled) return;
	BMFAssertReturn(self.object.navigationItem);
	
	[self.object.navigationItem setHidesBackButton:!self.showButton animated:self.animated];
}

@end
