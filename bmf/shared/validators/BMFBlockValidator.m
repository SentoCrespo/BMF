//
//  BMFBlockValidator.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/07/14.
//
//

#import "BMFBlockValidator.h"

#import "BMF.h"

@implementation BMFBlockValidator

- (instancetype) initWithBlock:(BMFValidatorBlock) block {
	BMFAssertReturnNil(block);
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void) setBlock:(BMFValidatorBlock)block {
	BMFAssertReturn(block);
	_block = [block copy];
}

- (BOOL) validate:(id) value {
	return self.block(value);
}

@end
