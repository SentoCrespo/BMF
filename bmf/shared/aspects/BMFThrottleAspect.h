//
//  BMFThrottleAspect.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 03/07/14.
//
//

#import "BMFAspect.h"

#import "BMFTypes.h"

@interface BMFThrottleAspect : BMFAspect

@property (nonatomic, assign) NSTimeInterval minimumTimeInterval;
@property (nonatomic, copy) BMFActionBlock actionBlock;
@property (nonatomic, copy) NSString *identifier;

/// 0 if not specified
@property (nonatomic, assign) NSTimeInterval tolerance;

- (instancetype) initWithInterval:(NSTimeInterval)interval actionBlock:(BMFActionBlock) actionBlock identifier:(NSString *) identifier;
- (instancetype) init __attribute__((unavailable("Use initWithInterval:actionBlock:identifier: instead")));

- (void) start;
- (void) stop;

/// Removes the last run date
- (void) clear;

@end
