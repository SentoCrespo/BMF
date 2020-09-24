//
//  BMFUrlSetting.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/9/14.
//
//

#import "BMFUrlSetting.h"

@implementation BMFUrlSetting

- (void) setValue:(id)value {
	
	NSURL *url = nil;
	
	if ([value isKindOfClass:[NSString class]]) {
		url = [NSURL URLWithString:value];
	}
	else if ([value isKindOfClass:[NSURL class]]) {
		url = value;
	}
	
	if (url) [super setValue:url];
}

- (BOOL) setDefaultRawValue:(id)value {
	NSString *stringValue = [NSString BMF_cast:value];
	if (stringValue) {
		self.defaultValue = [NSURL URLWithString:stringValue];
		return YES;
	}
	
	NSURL *url = [NSURL BMF_cast:value];
	if (url) {
		self.defaultValue = url;
		return YES;
	}
	
	return NO;
}

- (id) defaultRawValue {
	return [self.defaultValue absoluteString];
}

- (id) rawValue {
	return [self.value absoluteString];
}

- (BOOL) loadFromDictionary:(NSDictionary *) dic {
	return [self setDefaultRawValue:dic[@"defaultValue"]];
}

@end
