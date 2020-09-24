//
//  BMFRangeValueValidator.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 16/09/14.
//
//

#import "BMFValidator.h"

/// Validates that the value passed is between minValue and maxValue. If minValue or maxValue are nil, they are not checked. Both can't be nil or an exception will be thrown
@interface BMFRangeValueValidator : BMFValidator

@property (nonatomic, strong) NSNumber *minValue;
@property (nonatomic, strong) NSNumber *maxValue;

- (instancetype) initWithMinValue:(NSNumber *)minValue maxValue:(NSNumber *)maxValue;

@end
