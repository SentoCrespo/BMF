//
//  BMFUserDefaultsValue.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/07/14.
//
//

#import "BMFUserDefaultsValue.h"

#import "BMF.h"

@implementation BMFUserDefaultsValue

- (instancetype) initWithId:(NSString *) id {
	BMFAssertReturnNil(id);
	
    self = [super init];
    if (self) {
        _id = id;
    }
    return self;
}

- (void) setCurrentValue:(id) value {
	if (value==[self currentValue]) return;
	
	if (self.acceptValueValidator && ![self.acceptValueValidator validate:value]) return;
	
	[[NSUserDefaults standardUserDefaults] setValue:value forKeyPath:_id];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[self notifyValueChanged:self];
}

- (id) currentValue {
	return [self prepareValue:[[NSUserDefaults standardUserDefaults] valueForKey:_id]];
}

@end
