//
//  BMFDisposableObjectDataStore.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 28/08/14.
//
//

#import "BMFDisposableObjectDataStore.h"

#import "BMF.h"
#import "BMFObserverAspect.h"

@interface BMFDisposableObjectDataStore()

@property (nonatomic, strong) id value;

@end

@implementation BMFDisposableObjectDataStore

- (instancetype) initWithCreationBlock:(BMFCreationBlock) creationBlock {
	BMFAssertReturnNil(creationBlock);
	
    self = [super init];
    if (self) {
		_creationBlock = [creationBlock copy];
		
#if TARGET_OS_IPHONE
		BMFObserverAspect *memoryWarningAspect = [[BMFObserverAspect alloc] initWithName:UIApplicationDidReceiveMemoryWarningNotification block:^(id sender) {
			[self dispose];
		}];
		[self BMF_addAspect:memoryWarningAspect];
#endif
    }
    return self;
}

- (void) setCreationBlock:(BMFCreationBlock)creationBlock {
	BMFAssertReturn(creationBlock);
	
	_creationBlock = [creationBlock copy];

	[self dispose];
}

- (id) currentValue {
	if (!self.value) {
		self.value = self.creationBlock();
	}
	
	if (self.valueAdapter) {
		return [self.valueAdapter adapt:self.value];
	}
	
	return self.value;
}

- (void) dispose {
	self.value = nil;
}

@end
