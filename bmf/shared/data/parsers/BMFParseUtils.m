//
//  BMFParseUtils.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/07/14.
//
//

#import "BMFParseUtils.h"

#import "BMF.h"

@implementation BMFParseUtils

- (BOOL) validateString:(id) presumedString {
	return [self validateString:presumedString fieldName:nil];
}

- (BOOL) validateString:(id) presumedString fieldName:(NSString *) fieldName {
	return [self validateObject:presumedString class:[NSString class] fieldName:fieldName];
}

- (BOOL) validateNumber:(id) presumedNumber {
	return [self validateNumber:presumedNumber fieldName:nil];
}

- (BOOL) validateNumber:(id) presumedNumber fieldName:(NSString *) fieldName {
	return [self validateObject:presumedNumber class:[NSNumber class] fieldName:fieldName];
}

- (BOOL) validateDictionary:(id) presumedDictionary {
	return [self validateDictionary:presumedDictionary fieldName:nil];
}

- (BOOL) validateDictionary:(id) presumedDictionary fieldName:(NSString *) fieldName {
	return [self validateObject:presumedDictionary class:[NSDictionary class] fieldName:fieldName];
}

- (BOOL) validateArray:(id) presumedArray {
	return [self validateArray:presumedArray fieldName:nil];
}

- (BOOL) validateArray:(id) presumedArray fieldName:(NSString *) fieldName {
	return [self validateObject:presumedArray class:[NSArray class] fieldName:fieldName];
}

- (BOOL) validateObject:(id) object class:(Class) wantedClass {
	return [self validateObject:object class:wantedClass fieldName:nil];
}

- (BOOL) validateObject:(id) object class:(Class) wantedClass fieldName:(NSString *) fieldName {
	if ([object isKindOfClass:wantedClass]) return YES;
	if (fieldName) BMFLogErrorC(BMFLogCoreContext, @"Error: object %@ is not of kind: %@ in field: %@",object, wantedClass,fieldName);
	else BMFLogErrorC(BMFLogCoreContext, @"Error: object %@ is not of kind: %@",object, wantedClass);
	return NO;
}

@end
