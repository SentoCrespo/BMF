//
//  BMFBlockValidator.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/07/14.
//
//

#import "BMFValidator.h"

typedef BOOL(^BMFValidatorBlock)(id value);

@interface BMFBlockValidator : BMFValidator

@property (nonatomic, copy) BMFValidatorBlock block;

- (instancetype) initWithBlock:(BMFValidatorBlock) block;
- (instancetype) init __attribute__((unavailable("Use initWithBlock: instead")));

@end
