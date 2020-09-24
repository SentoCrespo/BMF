//
//  BMFObserverAspect.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/08/14.
//
//

#import "BMFAspect.h"

#import "BMFTypes.h"

typedef void(^BMFNotificationBlock)(NSNotification *notification);

@interface BMFObserverAspect : BMFAspect

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) id observedObject;
@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, copy) BMFNotificationBlock actionBlock;

- (instancetype) initWithName:(NSString *) name block:(BMFNotificationBlock)block;
- (instancetype) initWithName:(NSString *) name object:(id)object userInfo:(NSDictionary *)userInfo block:(BMFNotificationBlock)block;
- (instancetype) init __attribute__((unavailable("Use initWithName:block: instead")));

- (void) startObserving;
- (void) stopObserving;

@end
