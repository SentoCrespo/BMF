//
//  BMFNetworkUtils.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 19/2/15.
//
//

#import "BMFNetworkUtils.h"
#import "BMF.h"

#if TARGET_OS_IPHONE
@import SystemConfiguration.CaptiveNetwork;
#else
@import CoreWLAN;
#endif

@implementation BMFNetworkInfo

- (instancetype) initWithDictionary:(NSDictionary *) infoDic {
	BMFAssertReturnNil(infoDic);
	self = [super init];
	if (self) {
		_name = [infoDic[@"SSID"] copy];
		_bssid = [infoDic[@"BSSID"] copy];
	}
	return self;
}

@end

@implementation BMFNetworkUtils

+ (BMFNetworkInfo *) currentNetworkInfo {
	NSDictionary *infoDic = [self p_fetchSSIDInfo];
	if (!infoDic) return nil;
	return [[BMFNetworkInfo alloc] initWithDictionary:infoDic];
}

#if TARGET_OS_IPHONE
+ (id)p_fetchSSIDInfo {
	NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
	NSDictionary *info;
	for (NSString *ifnam in ifs) {
		info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
		if (info && [info count]) { break; }
	}
	return info;
}
#else
+ (id)p_fetchSSIDInfo {
	CWInterface *interface = [CWInterface interfaceWithName:nil];
	return @{
			 @"SSID" : [NSString BMF_nonNilString:interface.ssid],
			 @"BSSID" : [NSString BMF_nonNilString:interface.bssid]
			 };
}
#endif

@end
