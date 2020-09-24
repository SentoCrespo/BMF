//
//  BMFDataConnectionStatusBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/10/14.
//
//

#import "BMFViewControllerBehavior.h"

#import "BMFTypes.h"
#import "BMFDataConnectionCheckerProtocol.h"

@interface BMFDataConnectionStatusBehavior : BMFViewControllerBehavior<BMFDataConnectionCheckerProtocol>

@property (nonatomic, strong) BMFActionBlock actionBlock;

- (instancetype) initWithBlock:(BMFActionBlock)actionBlock;
- (instancetype) init __attribute__((unavailable("Use initWithBlock: instead")));

@end
