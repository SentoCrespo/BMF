//
//  BMFFixedValue.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 17/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFFixedValue.h"

#import "BMFTypes.h"

@implementation BMFFixedValue

- (instancetype) initWithValue:(id) value {
	self = [super init];
	if (self) {
		_value = value;
		[self performInit];
	}
	return self;
}

- (instancetype) init {
	return [self initWithValue:nil];
}

- (void) setValue:(id)value validate:(BOOL)validate notify:(BOOL) notify {
	
	if ([_value isEqual:value]) return;
	
	if (validate && self.acceptValueValidator && ![self.acceptValueValidator validate:value]) return;
	
	_value = value;
	
	if (notify) {
		[self notifyValueChanged:self];
	}
}

- (void) setValue:(id)value {
	[self setValue:value validate:YES notify:YES];
}

- (void) setCurrentValue:(id)value {
	[self setValue:value];
}

- (id) currentValue {
	return [self prepareValue:self.value];
}

- (void) performInit {}

#pragma mark NSCopying

- (instancetype) copyWithZone:(NSZone *) zone {
	BMFFixedValue *newValue = [BMFFixedValue new];
	
	id<NSCopying> validator = [NSObject BMF_castObject:self.acceptValueValidator withProtocol:@protocol(NSCopying)];
	if (validator) newValue.acceptValueValidator = [validator copyWithZone:zone];
	else return nil;
	
	newValue.value = [self.value copy];
	
	return newValue;
}

@end
