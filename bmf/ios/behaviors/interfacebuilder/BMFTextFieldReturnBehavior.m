//
//  BMFTextFieldReturnBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 28/1/15.
//
//

#import "BMFTextFieldReturnBehavior.h"

#import "BMF.h"

@interface BMFTextFieldReturnBehavior()

@end

@implementation BMFTextFieldReturnBehavior

- (void) viewDidLoad {
	if (!self.enabled) return;
	
	BMFAssertReturn(self.textFields.count>0);
	for (UITextField *field in self.textFields) {
		[self.object.BMF_proxy makeDelegateOf:field withSelector:@selector(setDelegate:)];
	}
}

- (BOOL) respondsToSelector:(SEL)selector withArguments:(NSArray *)arguments {
	if (selector!=@selector(textFieldShouldReturn:)) return [self respondsToSelector:selector];
	return ([self.textFields containsObject:arguments.firstObject]);
}

#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	if (!self.enabled) return self.stopEditingOnReturn;
	if (![self.textFields containsObject:textField]) return self.stopEditingOnReturn;
	
	if (self.textFieldReturnBlock) self.textFieldReturnBlock(textField);
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
	return self.stopEditingOnReturn;
}

@end
