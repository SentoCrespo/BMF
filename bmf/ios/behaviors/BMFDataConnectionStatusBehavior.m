//
//  BMFDataConnectionStatusBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/10/14.
//
//

#import "BMFDataConnectionStatusBehavior.h"

#import "BMFObserverBehavior.h"
#import "BMFBehaviorsViewControllerProtocol.h"

#import "BMF.h"

#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface BMFDataConnectionStatusBehavior()

@property (nonatomic, strong) id<BMFDataConnectionCheckerProtocol> networkChecker;

@end

@implementation BMFDataConnectionStatusBehavior

- (instancetype) initWithBlock:(BMFActionBlock)actionBlock {
	BMFAssertReturnNil(actionBlock);
	
	self = [super init];
	if (self) {
		_actionBlock = [actionBlock copy];
		
		self.networkChecker = [[BMFBase sharedInstance].factory dataConnectionChecker];
		
		[[AFNetworkReachabilityManager sharedManager] startMonitoring];
	}
	return self;
}

- (void) setObject:(UIViewController *)object {
	BMFAssertReturn(!object || [object conformsToProtocol:@protocol(BMFBehaviorsViewControllerProtocol)]);

	[super setObject:(id)object];
	
	if (!object) return;
	
	id<BMFBehaviorsViewControllerProtocol> vc = self.object;
	BMFObserverBehavior *observerBehavior = [[BMFObserverBehavior alloc] initWithName:AFNetworkingReachabilityDidChangeNotification block:^(id sender) {
		self.actionBlock(self);
	}];
	[vc addBehavior:observerBehavior];
}

- (void) setActionBlock:(BMFActionBlock)actionBlock {
	BMFAssertReturn(actionBlock);
	
	_actionBlock = [actionBlock copy];
}

#pragma mark BMFDataConnectionCheckerProtocol

- (BOOL) dataConnectionAvailable {
	return [self.networkChecker dataConnectionAvailable];
}

- (BMFDataConnectionKind) dataConnectionKind {
	return [self.networkChecker dataConnectionKind];
}

@end
