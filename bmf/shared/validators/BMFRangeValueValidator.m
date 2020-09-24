//
//  BMFRangeValueValidator.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 16/09/14.
//
//

#import "BMFRangeValueValidator.h"

#import "BMF.h"

@implementation BMFRangeValueValidator

- (instancetype) initWithMinValue:(NSNumber *)minValue maxValue:(NSNumber *)maxValue {
	self = [super init];
	if (self) {
		_minValue = minValue;
		_maxValue = maxValue;
	}
	return self;
}

- (BOOL) validate:(id) value {
	if (!value) return NO;
	
	BMFAssertReturnNO(self.minValue || self.maxValue);
	
	NSNumber *num = [NSNumber BMF_cast:value];
	
	if (self.minValue) {
		if ([self.minValue compare:num]==NSOrderedDescending) return NO;
	}
	
	if (self.maxValue) {
		if ([self.maxValue compare:num]==NSOrderedAscending) return NO;
	}
	
	return YES;
}

@end
