//
//  BMFBlockAdapter.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 22/09/14.
//
//

#import "BMFBlockAdapter.h"

#import "BMF.h"

@implementation BMFBlockAdapter

- (instancetype) initWithBlock:(BMFAdapterBlock) adapterBlock {
	BMFAssertReturnNil(adapterBlock);
	
	self = [super init];
	if (self) {
		_adapterBlock = [adapterBlock copy];
	}
	return self;
}

- (void) setAdapterBlock:(BMFAdapterBlock)adapterBlock {
	BMFAssertReturn(adapterBlock);
	
	_adapterBlock = [adapterBlock copy];
}

- (id) adapt:(id)value {
	return self.adapterBlock(value);
}

@end
