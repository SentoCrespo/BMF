//
//  BMFAverageValue.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 29/05/14.
//
//

#import "BMFValue.h"

@interface BMFAverageValue : BMFValue <NSCoding>

@property (nonatomic, strong) NSNumber *defaultValue;

/// 1 by default, which means no ponderation. The next value will be multiplied by this value, and the previous average will be multiplied by 2-ponderation
@property (nonatomic, assign) double ponderation;

- (instancetype) initWithDefaultValue:(NSNumber *) value;

- (void) clear;
- (void) addValue: (NSNumber *) number;
- (void) removeValue: (NSNumber *) number;

@end
