//
//  BMFRememberControlStateBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/3/15.
//
//

#import "BMFRememberControlValueBehavior.h"

#import "BMF.h"

@implementation BMFRememberControlValueBehavior

- (void) viewDidLoad {
	if (!self.enabled) return;
	BMFAssertReturn(self.key.length>0);
	BMFAssertReturn(self.control);
	
	[self restoreValue];
}

- (void) viewDidDisappear:(BOOL)animated {
	if (!self.enabled) return;
	BMFAssertReturn(self.key.length>0);
	BMFAssertReturn(self.control);
	
	[self saveValue];
}

- (void) restoreValue {
	UISwitch *switchControl = [UISwitch BMF_cast:self.control];
	if (switchControl) {
		switchControl.on = [[NSUserDefaults standardUserDefaults] boolForKey:self.key];
		return;
	}
	
	UISegmentedControl *segControl = [UISegmentedControl BMF_cast:self.control];
	if (segControl) {
		segControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:self.key];
		return;
	}
	
	UITextField *textField = [UITextField BMF_cast:self.control];
	if (textField) {
		textField.text = [[NSUserDefaults standardUserDefaults] valueForKey:self.key];
		return;
	}
	
	UITextView *textView = [UITextView BMF_cast:self.control];
	if (textView) {
		textView.text = [[NSUserDefaults standardUserDefaults] valueForKey:self.key];
		return;
	}
	
	BMFThrowException(@"Unknown control type");
}

- (void) saveValue {
	UISwitch *switchControl = [UISwitch BMF_cast:self.control];
	if (switchControl) {
		[[NSUserDefaults standardUserDefaults] setBool:switchControl.isOn forKey:self.key];
		return;
	}
	
	UISegmentedControl *segControl = [UISegmentedControl BMF_cast:self.control];
	if (segControl) {
		[[NSUserDefaults standardUserDefaults] setInteger:segControl.selectedSegmentIndex forKey:self.key];
		return;
	}
	
	UITextField *textField = [UITextField BMF_cast:self.control];
	if (textField) {
		[[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:self.key];
		return;
	}
	
	UITextView *textView = [UITextView BMF_cast:self.control];
	if (textView) {
		[[NSUserDefaults standardUserDefaults] setValue:textView.text forKey:self.key];
		return;
	}
	
	BMFThrowException(@"Unknown control type");
}

@end
