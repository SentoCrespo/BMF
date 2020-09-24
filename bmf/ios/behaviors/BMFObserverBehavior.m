//
//  BMFObserverBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/08/14.
//
//

#import "BMFObserverBehavior.h"

#import "BMFObserverAspect.h"

@interface BMFObserverBehavior()

@property (nonatomic, strong) BMFObserverAspect *aspect;

@end

@implementation BMFObserverBehavior

- (instancetype) initWithName:(NSString *) name block:(BMFActionBlock)block {
	return [self initWithName:name object:nil userInfo:nil block:block];
}

- (instancetype) initWithName:(NSString *) name object:(id)object userInfo:(NSDictionary *)userInfo block:(BMFActionBlock)block {
	self = [super init];
	if (self) {
		self.aspect = [[BMFObserverAspect alloc] initWithName:name object:object userInfo:userInfo block:block];
	}
	return self;
}

- (void) setName:(NSString *)name {
	self.aspect.name = name;
}

- (NSString *) name {
	return self.aspect.name;
}

- (void) setObservedObject:(id)observedObject {
	self.aspect.observedObject = observedObject;
}

- (id) observedObject {
	return self.aspect.observedObject;
}

- (void) setUserInfo:(NSDictionary *)userInfo {
	self.aspect.userInfo = userInfo;
}

- (NSDictionary *) userInfo {
	return self.aspect.userInfo;
}

- (void) setActionBlock:(BMFActionBlock)actionBlock {
	self.aspect.actionBlock = actionBlock;
}

- (BMFActionBlock) actionBlock {
	return self.aspect.actionBlock;
}

- (void) viewDidAppear:(BOOL)animated {
	[self.aspect startObserving];
}

- (void) viewDidDisappear:(BOOL)animated {
	[self.aspect stopObserving];
}

@end
