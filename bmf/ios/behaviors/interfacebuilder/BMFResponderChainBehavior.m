//
//  BMFResponderChainBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/07/14.
//
//

#import "BMFResponderChainBehavior.h"

#import "BMF.h"

@interface BMFResponderChainBehavior() <UITextFieldDelegate, UITextViewDelegate>

@end

@implementation BMFResponderChainBehavior

- (void) performInit {
	[super performInit];

	_lastResponderReturnKeyType = UIReturnKeyDefault;
}

- (void) viewDidLoad {
	[self updateResponders];
}

- (void) setResponders:(NSArray *)responders {
	BMFAssertReturn(responders.count>0);
	BMFAssertReturn([responders[0] isKindOfClass:[UIResponder class]]);

	/// TODO: Remove delegate from old responsers
	
	_responders = responders;
	[self updateResponders];
}

- (void) setObject:(UIViewController<BMFBehaviorsViewControllerProtocol> *)object{
	[super setObject:object];
	
	[self updateResponders];
}

- (void) updateResponders {
	[self.responders enumerateObjectsUsingBlock:^(UIResponder *responder, NSUInteger idx, BOOL *stop) {
		
		UITextField *textField = [UITextField BMF_cast:responder];
		if (textField) {
			[self.object.BMF_proxy makeDelegateOf:textField withSelector:@selector(setDelegate:)];
			
			if (idx==self.responders.count-1) {
				// Last responder
				textField.returnKeyType = _lastResponderReturnKeyType;
			}
			else {
				textField.returnKeyType = UIReturnKeyNext;
			}
		}
		
		UITextView *textView = [UITextView BMF_cast:responder];
		if (textView) {
			[self.object.BMF_proxy makeDelegateOf:textView withSelector:@selector(setDelegate:)];
		}
	}];
}

- (void) fieldDidEndEditing:(UIView *) field {
	NSInteger index = [self.responders indexOfObject:field];
	if (index==NSNotFound) return;
	
	index++;
	if (index>=self.responders.count) {
		if (!self.wrapAround) {
			if (self.lastResponderActionBlock) self.lastResponderActionBlock(self);
		}
		index = 0;
	}
	
	[self.responders[index] becomeFirstResponder];
}

#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	if (![self.responders containsObject:textField]) return NO;
	
	[self fieldDidEndEditing:textField];
	
	return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
	return YES;
}

#pragma mark UITextViewDelegate


- (void) textViewDidEndEditing:(UITextView *)textView {
	[self fieldDidEndEditing:textView];
}



@end
