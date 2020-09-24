//
//  TRNRangeValueSetting.m
//  geofence
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/09/14.
//  Copyright (c) 2014 Treenovum. All rights reserved.
//

#import "BMFRangeValueSetting.h"

#import "BMF.h"
#import "BMFRangeValueValidator.h"

@interface BMFRangeValueSetting()

@property (nonatomic, strong) BMFRangeValueValidator *rangeValidator;

@end

@implementation BMFRangeValueSetting

@dynamic value;

- (instancetype)initWithKey:(NSString *)key {
	self = [super initWithKey:key];
	if (self) {
		_rangeValidator = [BMFRangeValueValidator new];
	}
	return self;
}

- (void) setMinValue:(NSNumber *)minValue {
	_minValue = minValue;
	_rangeValidator.minValue = minValue;
}

- (void) setMaxValue:(NSNumber *)maxValue {
	_maxValue = maxValue;
	_rangeValidator.maxValue = maxValue;
}

- (void) setValue:(id)value {
	if ([_rangeValidator validate:value]) [super setValue:value];
}

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
	if (![self setDefaultRawValue:dic[@"defaultValue"]]) return NO;
	
	id parsedValue = [self numberFromRawValue:dic[@"minValue"]];
	if (!parsedValue) {
		BMFLogErrorC(BMFLogCoreContext,@"minValue not a valid number in dic: %@",dic);
		return NO;
	}
	else {
		self.minValue = parsedValue;
	}

	parsedValue = [self numberFromRawValue:dic[@"maxValue"]];
	if (!parsedValue) {
		BMFLogErrorC(BMFLogCoreContext,@"maxValue not a valid number in dic: %@",dic);
		return NO;
	}
	else {
		self.maxValue = parsedValue;
	}
	
	return YES;
}

@end
