//
//  BMFRealmObjectStore.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/10/14.
//
//

#import "BMFRealmObjectStore.h"

#import "BMF.h"

#import <Realm/Realm.h>

@interface BMFRealmObjectStore()

@property (nonatomic, strong) RLMNotificationToken *token;

@end

@implementation BMFRealmObjectStore

- (instancetype) initWithQueryBlock:(BMFRealmObjectQueryBlock) queryBlock realm:(RLMRealm *) realm {

	BMFAssertReturnNil(queryBlock);
	BMFAssertReturnNil(realm);
	
	self = [super init];
	if (self) {
		_queryBlock = [queryBlock copy];
		_realm = realm;
	}
	return self;
}

- (void) dealloc {
	[self stopObserving];
}

- (void) setQueryBlock:(BMFRealmObjectQueryBlock)queryBlock {
	BMFAssertReturn(queryBlock);
	_queryBlock = [queryBlock copy];
}

- (void) setRealm:(RLMRealm *)realm {
	BMFAssertReturn(realm);
	
	_realm = realm;
}

- (void) stopObserving {
	[self.realm removeNotification:self.token];
	self.token = nil;
}

- (void) startObserving {
	[self stopObserving];
	
	self.token = [self.realm addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
		if (self.applyValueBlock) self.applyValueBlock(self);
		[[NSNotificationCenter defaultCenter] postNotificationName:BMFValueChangedNotification object:self];
	}];
}

- (id) currentValue {
	return [self prepareValue:self.queryBlock()];
}

@end
