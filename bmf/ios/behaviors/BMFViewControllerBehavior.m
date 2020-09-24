//
//  BMFViewControllerBehavior.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFViewControllerBehavior.h"

#import "BMF.h"

@implementation BMFViewControllerBehavior

@dynamic enabled;

- (instancetype) init {
    self = [super init];
    if (self) {
		[self performInit];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self performInit];
	}
	return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self performInit];
	}
	return self;
}

- (void) performInit { }

- (void) awakeFromNib {
	// If we are in a nib we need an owner or we will be deallocated
	BMFAssertReturn(self.owner);
}

- (void) setOwner:(UIViewController<BMFBehaviorsViewControllerProtocol> *)owner {
	BMFAssertReturn([owner isKindOfClass:[UIViewController class]] && [owner conformsToProtocol:@protocol(BMFBehaviorsViewControllerProtocol)]);
	[owner addBehavior:self];
}

- (UIViewController<BMFBehaviorsViewControllerProtocol> *) owner {
	return self.object;
}

- (void) setObject:(UIViewController<BMFBehaviorsViewControllerProtocol> *)object {
	BMFAssertReturn([object isKindOfClass:[UIViewController class]] && [object conformsToProtocol:@protocol(BMFBehaviorsViewControllerProtocol)]);
	
	_object = object;
}

@end
