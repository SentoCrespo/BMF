//
//  BMFValue.m
//  ExampleMac
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/04/14.
//  Copyright (c) 2014 josé manuel sánchez. All rights reserved.
//

#import "BMFValue.h"

BMFDefineGlobalNotificationConstant(BMFValueChangedNotification);

@implementation BMFValue

- (void) setApplyValueBlock:(BMFActionBlock)applyValueBlock {
	_applyValueBlock = [applyValueBlock copy];
	
	[self notifyValueChanged:self];
}

- (void) setSignalBlock:(BMFActionBlock)signalBlock {
	_signalBlock = [signalBlock copy];
	
	[self notifyValueChanged:self];
}

- (id) prepareValue:(id) value {
	id result = value;
	
	if (![value BMF_isNotNull]) return nil;
	BMFValue *boxedValue = [BMFValue BMF_cast:value];
	if (boxedValue) {
		result = [boxedValue currentValue];
	}
	
	if (self.valueAdapter) {
		result = [self.valueAdapter adapt:result];
	}
	
	return result;
}

- (id) currentValue {
	return nil;
}

- (IBAction) notifyValueChanged:(id)sender {
	BMFSupressDeprecationWarning(if (self.applyValueBlock) self.applyValueBlock(self););
	if (self.signalBlock) self.signalBlock(self.currentValue);
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFValueChangedNotification object:self];
}

- (NSString *) description {
	return [NSString stringWithFormat:@"<%@: %p,currentValue: %@>",NSStringFromClass([self class]), self,self.currentValue];
}

@end
