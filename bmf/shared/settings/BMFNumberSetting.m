//
//  BMFNumberSetting.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/12/14.
//
//

#import "BMFNumberSetting.h"

@implementation BMFNumberSetting

@dynamic value;

- (BOOL) setDefaultRawValue:(id)value {
	
	NSNumber *parsedNumber = [self numberFromRawValue:value];
	if (parsedNumber) {
		self.defaultValue = parsedNumber;
		return YES;
	}
	else {
		BMFLogErrorC(BMFLogCoreContext,@"defaultValue not a valid number: %@",value);
	}
	
	return NO;
}

- (NSNumber *) numberFromRawValue:(id) value {
	NSString *stringValue = [[NSString BMF_cast:value] lowercaseString];
	if (stringValue) {
		return @([stringValue doubleValue]);
	}
	
	NSNumber *number = [NSNumber BMF_cast:value];
	if (number) {
		return number;
	}
	
	return nil;
}

- (BOOL) loadFromDictionary:(NSDictionary *) dic {
	return [self setDefaultRawValue:dic[@"defaultValue"]];
}

@end
