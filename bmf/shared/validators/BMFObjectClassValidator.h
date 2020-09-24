//
//  BMFObjectClassValidator.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/09/14.
//
//

#import "BMFValidator.h"

@interface BMFObjectClassValidator : BMFValidator

@property (nonatomic, strong) Class validObjectClass;

- (instancetype) initWithClass:(Class) validObjectClass;
- (instancetype) init __attribute__((unavailable("Use initWithClass: instead")));

@end
