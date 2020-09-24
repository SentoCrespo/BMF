//
//  BMFEnableControlBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/11/14.
//
//

#import "BMFEnableControlBehavior.h"

#import "BMF.h"

@implementation BMFEnableControlBehavior

- (IBAction)enable:(id) sender {
	if (!self.isEnabled) return;
	
	BMFAssertReturn(self.controls.count>0);
	
	for (UIControl *control in self.controls) {
		control.enabled = YES;
	}
}

- (IBAction)disable:(id) sender {
	if (!self.isEnabled) return;
	
	BMFAssertReturn(self.controls.count>0);

	for (UIControl *control in self.controls) {
		control.enabled = NO;
	}
}

@end
