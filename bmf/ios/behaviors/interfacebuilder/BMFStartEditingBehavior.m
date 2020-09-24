//
//  BMFStartEditingBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/11/14.
//
//

#import "BMFStartEditingBehavior.h"

#import "BMF.h"

@implementation BMFStartEditingBehavior

- (IBAction) startEditing:(id)sender {
	if (!self.isEnabled) return;
	
	BMFAssertReturn(self.control);
	
	[self.control becomeFirstResponder];
}

@end
