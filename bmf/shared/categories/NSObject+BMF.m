//
//  NSObject+BMFCast.m
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/01/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import "NSObject+BMF.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation NSObject (BMF)

- (BOOL) BMF_isKindInClasses:(NSArray *) classes {
	for (Class c in classes) {
		if ([self isKindOfClass:c]) return YES;
	}
	
	return NO;
}

+ (instancetype) BMF_cast:(id)from {
	if ([from isKindOfClass:self]) {
        return from;
    }
    return nil;
}

- (id) BMF_castWithProtocol:(Protocol *) protocol {
	return [NSObject BMF_castObject:self withProtocol:protocol];
}

+ (id) BMF_castObject:(id)object withProtocol:(Protocol *) protocol {
	if ([object conformsToProtocol:protocol]) return object;
	return nil;
}

- (BOOL) BMF_isNotNull {
	return ((NSNull *)self!=[NSNull null]);
}

+ (id) BMF_objectOrNull:(id)object {
	if (object) return object;
	return [NSNull null];
}

- (void) BMF_addDisposableProperty:(NSString *) keyPath {

	#if TARGET_OS_IPHONE
	
	@weakify(self);
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil] subscribeNext:^(id x) {
		@strongify(self);
		[self setValue:nil forKey:keyPath];
	}];
	
	#endif
}

- (BOOL) BMF_conformsToProtocols:(NSArray *) protocols {
	for (Protocol *p in protocols) {
		if (![self conformsToProtocol:p]) return NO;
	}
	return YES;
}

@end
	
