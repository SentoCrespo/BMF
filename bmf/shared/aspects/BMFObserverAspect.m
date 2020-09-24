//
//  BMFObserverAspect.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/08/14.
//
//

#import "BMFObserverAspect.h"

#import "BMF.h"

@implementation BMFObserverAspect {
	id observationToken;
}

- (instancetype) initWithName:(NSString *) name block:(BMFNotificationBlock)block {
	return [self initWithName:name object:nil userInfo:nil block:block];
}

- (instancetype) initWithName:(NSString *) name object:(id)object userInfo:(NSDictionary *)userInfo block:(BMFNotificationBlock)block {
	BMFAssertReturnNil(name.length>0);
	BMFAssertReturnNil(block);
	
	self = [super init];
	if (self) {
		_name = [name copy];
		_observedObject = object;
		_userInfo = userInfo;
		_actionBlock = [block copy];

		[self startObserving];
	}
	return self;
}

- (void) setName:(NSString *)name {
	BMFAssertReturn(name.length>0);
	
	_name = [name copy];
}

- (void) setActionBlock:(BMFNotificationBlock)actionBlock {
	BMFAssertReturn(actionBlock);
	
	_actionBlock = [actionBlock copy];
}

- (void) dealloc {
	[self stopObserving];
}

- (void) startObserving {
	[self stopObserving];
	observationToken = [[NSNotificationCenter defaultCenter] addObserverForName:_name object:_observedObject queue:nil usingBlock:_actionBlock];
}

- (void) stopObserving {
	if (observationToken) [[NSNotificationCenter defaultCenter] removeObserver:observationToken];
	observationToken = nil;
}

@end
