//
//  TRNSetting.m
//  geofence
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/09/14.
//  Copyright (c) 2014 Treenovum. All rights reserved.
//

#import "BMFSetting.h"

@implementation BMFSetting

@dynamic applyValueBlock;

- (instancetype) initWithKey:(NSString *)key {
	BMFAssertReturnNil(key.length>0);
	self = [super initWithValue:nil];
	if (self ) {
		_userDefaults = [NSUserDefaults standardUserDefaults];
		_key = [key copy];
		[self startObserving];
	}
	return self;
}

- (void) dealloc {
	[self stopObserving];
}

- (void) setKey:(NSString *)key {
	BMFAssertReturn(key.length>0);
	
	[self stopObserving];
	_key = key;
	[self startObserving];
}

- (BOOL) setDefaultRawValue:(id)value {
	BMFAbstractMethod();
	return NO;
}

- (BOOL) loadFromDictionary:(NSDictionary *) dic {
	BMFAbstractMethod();
	return NO;
}

#pragma mark Observe

- (void) startObserving {
	if (_key.length>0) [self.userDefaults addObserver:self forKeyPath:_key options:NSKeyValueObservingOptionNew context:nil];
}

- (void) stopObserving {
	if (_key.length>0) [self.userDefaults removeObserver:self forKeyPath:self.key];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	id oldValue = self.value;
	[self load];
	if (self.value!=oldValue) {
		if (self.applyValueBlock) self.applyValueBlock(self);
	}
}

- (void) setValue:(id)value {
	[super setValue:value];
	[self save];
}

- (id) value {
	if (![super value]) {
		[self load];
	}
	
	id result = [super value];
	if (!result) return self.defaultValue;
	
	return result;
}

- (id) rawValue {
	return self.value;
}

- (id) defaultRawValue {
	return [self defaultValue];
}

- (void) load {
	BMFAssertReturn(self.key.length>0);
	
	[super setValue:[self.userDefaults valueForKey:self.key]];
}

- (void) save {
	[self.userDefaults setValue:self.value forKey:self.key];
	[self.userDefaults synchronize];
}

- (NSString *) description {
	return [NSString stringWithFormat:@"<%@: %p,name: %@, key: %@,defaultValue: %@, currentValue: %@, user adjustable: %d>",NSStringFromClass([self class]), self,self.name,self.key,self.defaultValue,self.currentValue,self.userAdjustable];
}

@end
