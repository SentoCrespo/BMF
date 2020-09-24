//
//  BMFFixedValue.h
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 17/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFValue.h"

#import "BMFValidatorProtocol.h"

@interface BMFFixedValue : BMFValue <BMFValueChangeProtocol>

/// nil by default. You can use this property to only accept some values but not others
@property (nonatomic, strong) id<BMFValidatorProtocol> acceptValueValidator;

/// Can be nil
@property (nonatomic, strong) id value;

/// This is mainly for subclasses. In general you shouldn't use this
- (void) setValue:(id)value validate:(BOOL)validate notify:(BOOL) notify;

/// Allows value nil, so you can use new or init instead. Designated initializer
- (instancetype) initWithValue:(id) value;

- (void) setCurrentValue:(id)value;

- (void) performInit __attribute((objc_requires_super));

@end
