//
//  BMFAFNetworkingDataConnectionChecker.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/07/14.
//
//

#import "BMFAFNetworkingDataConnectionChecker.h"

#import <AFNetworking/AFNetworking.h>

#import "BMF.h"

@implementation BMFAFNetworkingDataConnectionChecker

+ (void) initialize {
	[[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (BOOL) dataConnectionAvailable {
	AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
	return (reachabilityManager.reachable || [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus==AFNetworkReachabilityStatusUnknown);
}

- (BMFDataConnectionKind) kindforStatus: (AFNetworkReachabilityStatus) status {
	if (status==AFNetworkReachabilityStatusNotReachable) return BMFDataConnectionNotReachable;
	if (status==AFNetworkReachabilityStatusReachableViaWiFi) return BMFDataConnectionWiFi;
	if (status==AFNetworkReachabilityStatusReachableViaWWAN) return BMFDataConnectionWWAN;
	if (status==AFNetworkReachabilityStatusUnknown) return BMFDataConnectionUnknown;
	
	BMFThrowException(unknown network reachability status);
	return BMFDataConnectionUnknown;
}

- (BMFDataConnectionKind) dataConnectionKind {
	return [self kindforStatus:[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus];
}

@end
