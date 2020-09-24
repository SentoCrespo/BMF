//
//  BMFAverageValue.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 29/05/14.
//
//

#import "BMFAverageValue.h"

@interface BMFAverageValue()

@property (nonatomic, strong) NSNumber *averageValue;
@property (nonatomic, assign) NSUInteger numValues;

@end

@implementation BMFAverageValue

- (instancetype) initWithDefaultValue:(NSNumber *) value {
	self = [super init];
	if (self) {
		_defaultValue = value;
		_ponderation = 1;
	}
	return self;
}

- (instancetype) init {
	return [self initWithDefaultValue:nil];
}

- (void) setDefaultValue:(NSNumber *)defaultValue {
	_defaultValue = defaultValue;
	
	[self notifyValueChanged:self];
}

- (id) currentValue {
	NSNumber *result = self.defaultValue;
	if (self.numValues>0) {
		result = self.averageValue;
	}
	
	return [self prepareValue:result];
}

- (void) clear {
	self.numValues = 0;
	self.averageValue = nil;
}

- (void) addValue: (NSNumber *) number {
	BMFAssertReturn(number);
	
	if (self.numValues==0) {
		self.numValues = 1;
		self.averageValue = number;
		return;
	}
	
	double newItem = number.doubleValue;
	double average = self.averageValue.doubleValue;
	NSUInteger nextNumValues = self.numValues+1;
	
	average = average*(2-self.ponderation)*self.numValues/nextNumValues + newItem*self.ponderation/nextNumValues;
	
	self.numValues = nextNumValues;
	self.averageValue = @(average);
}

- (void) removeValue: (NSNumber *) number {
	BMFAssertReturn(number);
	BMFAssertReturn(self.numValues>0);
	
	double itemToRemove = number.doubleValue;
	double average = self.averageValue.doubleValue;
	NSUInteger nextNumValues = self.numValues-1;

	average = average*(2-self.ponderation)*self.numValues/nextNumValues - itemToRemove*self.ponderation/nextNumValues;

	self.numValues = nextNumValues;
	self.averageValue = @(average);
}

#pragma mark NSCoding

- (void) encodeWithCoder:(NSCoder *)aCoder {
	if (self.defaultValue) [aCoder encodeObject:self.defaultValue forKey:@"defaultValue"];
	if (self.averageValue) [aCoder encodeObject:self.averageValue forKey:@"averageValue"];
	[aCoder encodeInteger:self.numValues forKey:@"numValues"];
	[aCoder encodeDouble:self.ponderation forKey:@"ponderation"];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		_defaultValue = [aDecoder decodeObjectForKey:@"defaultValue"];
		_averageValue = [aDecoder decodeObjectForKey:@"averageValue"];
		_numValues = [aDecoder decodeIntegerForKey:@"numValues"];
		_ponderation = [aDecoder decodeDoubleForKey:@"ponderation"];
	}
	return self;
}

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
	BMFAverageValue *newAverageValue = [[BMFAverageValue alloc] initWithDefaultValue:[self.defaultValue copy]];
	newAverageValue.ponderation = self.ponderation;
	newAverageValue.averageValue = [self.averageValue copy];
	newAverageValue.numValues = self.numValues;
	
	return newAverageValue;
}

@end
