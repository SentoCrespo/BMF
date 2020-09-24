//
//  BMFObserverBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/08/14.
//
//

#import "BMFViewControllerBehavior.h"

#import "BMFTypes.h"

@interface BMFObserverBehavior : BMFViewControllerBehavior

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) id observedObject;
@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, copy) BMFActionBlock actionBlock;

- (instancetype) initWithName:(NSString *) name block:(BMFActionBlock)block;
- (instancetype) initWithName:(NSString *) name object:(id)object userInfo:(NSDictionary *)userInfo block:(BMFActionBlock)block;
- (instancetype) init __attribute__((unavailable("Use initWithName:block: instead")));

@end
