//
//  NSObject+BMFCast.h
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/01/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <objc/runtime.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

#define BMFAddDisposableProperty(TARGET,KEYPATH) \
	[(id)(TARGET) BMF_addDisposableProperty:@keypath(TARGET, KEYPATH)]

@interface NSObject (BMF)

/// Returns YES if self is a kind of one the classes passed
- (BOOL) BMF_isKindInClasses:(NSArray *) classes;

+ (instancetype) BMF_cast:(id)from;

- (id) BMF_castWithProtocol:(Protocol *) protocol;
+ (id) BMF_castObject:(id)object withProtocol:(Protocol *) protocol;

- (BOOL) BMF_isNotNull;
+ (id) BMF_objectOrNull:(id)object;

- (void) BMF_addDisposableProperty:(NSString *) keyPath;

- (BOOL) BMF_conformsToProtocols:(NSArray *) protocols;

@end
