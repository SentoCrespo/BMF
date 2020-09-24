//
//  BMFProxy.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFArrayProxy.h"

#import "BMF.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BMFArrayProxy()

@property (nonatomic) NSMutableSet *destinationObjects;
@property (nonatomic) RACSubject *destinationsSignal;
@property (nonatomic) dispatch_queue_t serialQueue;
@property (nonatomic) NSMapTable *delegatedObjectsTable;

@property (nonatomic) NSCache *selectorsCache;

@end

@implementation BMFArrayProxy

- (instancetype)init {
	if (self) {
		_serialQueue = dispatch_queue_create("Proxy queue", DISPATCH_QUEUE_SERIAL);
		
		_destinationObjects = [NSMutableSet set];
		_destinationsSignal = [RACSubject subject];
		_delegatedObjectsTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
		
		_selectorsCache = [NSCache new];
	}
	return self;
}
+ (instancetype)new {
	return [[BMFArrayProxy alloc] init];
}

- (void) dealloc {
	[(RACSubject *)self.destinationsSignal sendCompleted];
	[self removeAllDestinationObjects];
}

- (void) setObject:(id)object {
	dispatch_sync(self.serialQueue, ^{
		for (id obj in self.destinationObjects) {
			if ([obj respondsToSelector:@selector(setObject:)]) {
				dispatch_async(dispatch_get_main_queue(), ^{
					[obj setObject:object];
				});
			}
		}
	});
	
	_object = object;
}

- (void) addDestinationObject:(id) object {
	
	BMFAssertReturn(object);
	BMFAssertReturn(object!=self.object);
	
	if (self.object && [object respondsToSelector:@selector(setObject:)]) {
		[object setObject:self.object];
	}
	
	__block NSSet *destinationsCopy = nil;
	dispatch_sync(self.serialQueue, ^{
		[self.destinationObjects addObject:object];
		destinationsCopy = [self.destinationObjects copy];
	});
	
	[(RACSubject *)self.destinationsSignal sendNext:destinationsCopy];
	[self p_destinationObjectsChanged];
}

- (void) removeDestinationObject:(id) object {
	
	__block NSSet *destinationsCopy = nil;
	dispatch_sync(self.serialQueue, ^{
		if (object) [self.destinationObjects removeObject:object];
		destinationsCopy = [self.destinationObjects copy];
	});
	
	[(RACSubject *)self.destinationsSignal sendNext:destinationsCopy];
	[self p_destinationObjectsChanged];
}

- (void) removeAllDestinationObjects {
	dispatch_sync(self.serialQueue, ^{
		[self.destinationObjects removeAllObjects];
	});
	
	[(RACSubject *)self.destinationsSignal sendNext:[NSSet set]];
	[self p_removeAsDelegateOfAll];
}

- (BOOL) conformsToProtocol:(Protocol *)aProtocol {
	for (id destinationObject in self.destinationObjects) {
		if ([destinationObject conformsToProtocol:aProtocol]) return YES;
	}
	
	return NO;
}

- (void) makeDelegateOf:(id)object withSelector:(SEL)selector {
	BMFAssertReturn(object);
	NSMutableSet *selectorsSet = [self.delegatedObjectsTable objectForKey:object];
	if (!selectorsSet) selectorsSet = [NSMutableSet set];
	[selectorsSet addObject:NSStringFromSelector(selector)];
	[self.delegatedObjectsTable setObject:selectorsSet forKey:object];
	BMFSuppressPerformSelectorLeakWarning([object performSelector:selector withObject:self];);
}

- (void) removeDelegateOf:(id)object withSelector:(SEL)selector {
	BMFAssertReturn(object);
	BMFSuppressPerformSelectorLeakWarning([object performSelector:selector withObject:nil];);
	
	NSMutableSet *selectorsSet = [self.delegatedObjectsTable objectForKey:object];
	[selectorsSet removeObject:NSStringFromSelector(selector)];
	
	if (selectorsSet.count==0) [self.delegatedObjectsTable removeObjectForKey:object];
	else [self.delegatedObjectsTable setObject:selectorsSet forKey:object];
}

- (void)p_removeAsDelegateOfAll {
	/// Update the delegates by setting them to nil and then again to the current object
	for (id object in self.delegatedObjectsTable) {
		NSMutableSet *selectorsSet = [self.delegatedObjectsTable objectForKey:object];
		for (NSString *selectorName in selectorsSet) {
			SEL selector = NSSelectorFromString(selectorName);
			BMFSuppressPerformSelectorLeakWarning(
												  [object performSelector:selector withObject:nil];
												  );
		}
	}
}

- (void)p_destinationObjectsChanged {
	/// Update the delegates by setting them to nil and then again to the current object
	for (id object in self.delegatedObjectsTable) {
		NSMutableSet *selectorsSet = [self.delegatedObjectsTable objectForKey:object];
		for (NSString *selectorName in selectorsSet) {
			SEL selector = NSSelectorFromString(selectorName);
			BMFSuppressPerformSelectorLeakWarning(
												  [object performSelector:selector withObject:nil];
												  [object performSelector:selector withObject:self];
												  );
		}
	}
}

- (BOOL)respondsToSelector:(SEL)aSelector {
	//#warning Check if this works ok
	//	return YES;
	
	__block BOOL result = NO;
	dispatch_sync(self.serialQueue, ^{
		for (id obj in self.destinationObjects) {
			if ([obj respondsToSelector:aSelector]) {
				result = YES;
				return;
			}
		}
	});
	
	return result;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
	__block NSMethodSignature *sig = nil;
	
	dispatch_sync(self.serialQueue, ^{
		for(id obj in self.destinationObjects) {
			sig = [self p_signatureForObj:obj selector:sel];
			if (sig) return;
		}
	});
	
	return sig;
}

+ (NSString *) keyForObject:(id)obj selector:(SEL) sel {
	char cString[555];
	sprintf(cString,"%p_%s", &obj,NSStringFromSelector(sel).cString);
	return [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
//	return [NSString stringWithFormat:@"%p%@",&obj,NSStringFromSelector(sel)];
}

- (NSMethodSignature *) p_signatureForObj:(id)obj selector:(SEL) sel {
	NSString *key = [BMFArrayProxy keyForObject:obj selector:sel];
	NSMethodSignature *sig = [self p_signatureForKey:key];
	if (sig) return sig;
	sig = [obj methodSignatureForSelector:sel];
	if (!sig) return nil;
	[self p_setSignature:sig forKey:key];
	return sig;
}

- (NSMethodSignature *) p_signatureForKey:(NSString *) key {
	return [self.selectorsCache objectForKey:key];
}

- (void) p_setSignature:(NSMethodSignature *) sig forKey:(NSString *) key {
	[self.selectorsCache setObject:sig forKey:key];
}

- (void)forwardInvocation:(NSInvocation *)inv {
	__block NSArray *objects = nil;
	dispatch_sync(self.serialQueue, ^{
		objects = self.destinationObjects.allObjects;
	});
	
	for(id obj in objects) {
#if TARGET_OS_IPHONE
		if ([obj respondsToSelector:@selector(respondsToSelector:withArguments:)]) {
			if ([obj respondsToSelector:inv.selector withArguments:[self argumentsFromInvocation:inv]]) {
				[inv invokeWithTarget:obj];
			}
		}
#endif
		
		if ([obj respondsToSelector:inv.selector]) {
			[inv invokeWithTarget:obj];
		}
	}
}

- (NSArray *) argumentsFromInvocation:(NSInvocation *) invocation {
	NSMutableArray *arguments = [NSMutableArray array];
	NSUInteger numArguments = [invocation.methodSignature numberOfArguments];
	for (int i=2;i<numArguments;i++) {
		id argument;
		[invocation getArgument:&argument atIndex:i];
		if (argument) [arguments addObject:argument];
		else [arguments addObject:[NSNull null]];
	}
	return arguments;
}

@end
