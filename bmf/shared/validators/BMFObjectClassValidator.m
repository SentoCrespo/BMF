//
//  BMFObjectClassValidator.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/09/14.
//
//

#import "BMFObjectClassValidator.h"

#import "BMF.h"

@implementation BMFObjectClassValidator

- (instancetype) initWithClass:(Class) validObjectClass {
	BMFAssertReturnNil(validObjectClass);
	
    self = [super init];
    if (self) {
		_validObjectClass = validObjectClass;
    }
    return self;
}

- (void) setValidObjectClass:(Class)validObjectClass {
	BMFAssertReturn(validObjectClass);
	
	_validObjectClass = validObjectClass;
}

- (BOOL) validate:(id) value {
	return [value isKindOfClass:self.validObjectClass];
}

@end
