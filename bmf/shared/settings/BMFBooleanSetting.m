//
//  TRNBooleanSetting.m
//  geofence
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/09/14.
//  Copyright (c) 2014 Treenovum. All rights reserved.
//

#import "BMFBooleanSetting.h"

@implementation BMFBooleanSetting

- (void) setOn:(BOOL)on {
	self.value = @(on);
}

- (BOOL) on {
	if (!self.value) return NO;
	
	return [self.value boolValue];
}

- (BOOL) setDefaultRawValue:(id)value {
	NSString *stringValue = [[NSString BMF_cast:value] lowercaseString];
	if ([stringValue isEqualToString:@"true"]) {
		self.defaultValue = @YES;
		return YES;
	}
	else if ([stringValue isEqualToString:@"false"]) {
		self.defaultValue = @NO;
		return YES;
	}
	
	NSNumber *number = [NSNumber BMF_cast:value];
	if (number) {
		self.defaultValue = number;
		return YES;
	}
	
	return NO;
}

- (BOOL) loadFromDictionary:(NSDictionary *) dic {
	return [self setDefaultRawValue:dic[@"defaultValue"]];
}

@end
