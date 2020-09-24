//
//  BMFUserDefaultsValue.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/07/14.
//
//

#import "BMFValue.h"

@interface BMFUserDefaultsValue : BMFValue <BMFValueChangeProtocol>

@property (nonatomic, strong) id<BMFValidatorProtocol> acceptValueValidator;

@property (nonatomic, readonly) NSString *id;

- (void) setCurrentValue:(id) value;

- (instancetype) initWithId:(NSString *) id;
- (instancetype) init __attribute__((unavailable("Use initWithId: instead")));

@end
