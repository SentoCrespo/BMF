//
//  BMFDisplayAppVersionBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 27/1/15.
//
//

#import "BMFDisplayAppVersionBehavior.h"

#import "BMF.h"

@implementation BMFDisplayAppVersionBehavior

- (void) viewDidLoad {
	if (!self.enabled) return;
	
	BMFAssertReturn(self.label);
	
	if (!self.formatString) self.formatString = NSLocalizedString(@"Version: %@ (%@)", nil);
	else self.formatString = NSLocalizedString(self.formatString, nil);
	
	self.label.text = [NSString stringWithFormat:self.formatString,[BMFUtils appVersion],[BMFUtils appBuild]];
}

@end
