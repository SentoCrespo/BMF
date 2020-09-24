//
//  BMFBinding.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/11/14.
//
//

#import "BMFBinding.h"

#import "BMFObserverAspect.h"

#import <ReactiveCocoa/RACEXTScope.h>

@interface BMFBinding()

@property (nonatomic, strong) BMFObserverAspect *observerAspect;

@end

@implementation BMFBinding

- (void) setModel:(id)model {
	_model = model;
	[self update];
}

- (void) setControl:(BMFIXControl *)control {
	_control = control;
	[self update];
}

- (void) setPropertyName:(NSString *)propertyName {
	_propertyName = propertyName;
	[self update];
}

- (void) awakeFromNib {
	BMFAssertReturn(self.model && self.control && self.propertyName);
	
	[self update];
}

- (void) update {
	if (!self.model || !self.control || self.propertyName.length==0) return;
	
#if TARGET_OS_IPHONE
	
	@weakify(self);
	[[self.model rac_valuesForKeyPath:self.propertyName observer:self] subscribeNext:^(id value) {
		@strongify(self);
		
		if ([value isKindOfClass:[NSString class]]) {
			UILabel *label = [UILabel BMF_cast:self.control];
			if (label) {
				label.text = value;
			}
			else {
				UIButton *button = [UIButton BMF_cast:self.control];
				if (button) {
					[button setTitle:value forState:UIControlStateNormal];
				}
				else {
					
				}
			}
		}
		else if ([value isKindOfClass:[NSNumber class]]) {
			UISwitch *switchControl = [UISwitch BMF_cast:self.control];
			if (switchControl) {
				switchControl.on = [value boolValue];
			}
		}
		else if ([value isKindOfClass:[NSDate class]]) {
			UIDatePicker *datePicker = [UIDatePicker BMF_cast:self.control];
			if (datePicker) {
				datePicker.date = value;
			}
		}
		
	}];
	
#endif
	
}

@end
