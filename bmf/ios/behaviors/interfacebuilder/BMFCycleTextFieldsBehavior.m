//
//  BMFCycleTextFieldsBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 28/1/15.
//
//

#import "BMFCycleTextFieldsBehavior.h"

#import "BMF.h"

@interface BMFCycleTextFieldsBehavior() <UITextFieldDelegate, UITextViewDelegate>

@end

@implementation BMFCycleTextFieldsBehavior

//- (BOOL) respondsToSelector:(SEL)selector withArguments:(NSArray *)arguments {
//	if (selector!=@selector(textFieldShouldReturn:)) return [super respondsToSelector:selector];
//	if (!self.enabled) return NO;
//	return ([self.textFields containsObject:arguments.firstObject]);
//}

#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	BMFAssertReturnNO(self.enabled);
	BMFAssertReturnNO(self.textFields.count>0);

	[self fieldDidEndEditing:textField];
	
	return NO;
}

#pragma mark UITextViewDelegate

- (void) textViewDidEndEditing:(UITextView *)textView {
	[self fieldDidEndEditing:textView];
}

- (void) fieldDidEndEditing:(UIView *) field {
	NSInteger index = [self.textFields indexOfObject:field];
	if (index==NSNotFound) return;
	
	index++;
	if (index>=self.textFields.count) {
		if (!self.wrapAround) return;
		index = 0;
	}
	
	[self.textFields[index] becomeFirstResponder];
}

@end
