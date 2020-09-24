//
//  BMFStringSetting.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/9/14.
//
//

#import "BMFStringSetting.h"

@implementation BMFStringSetting

- (void) setValue:(id)value {
	BMFAssertReturn(!value || [value isKindOfClass:[NSString class]]);
	[super setValue:value];
}

- (BOOL) setDefaultRawValue:(id)value {
	NSString *stringValue = [NSString BMF_cast:value];
	if (stringValue) {
		self.defaultValue = stringValue;
		return YES;
	}
	
	return NO;
}

- (BOOL) loadFromDictionary:(NSDictionary *) dic {
	return [self setDefaultRawValue:dic[@"defaultValue"]];
}

@end
