//
//  BMFDataConnectionCheckerProtocol.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/07/14.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BMFDataConnectionKind) {
    BMFDataConnectionUnknown,
	BMFDataConnectionNotReachable,
	BMFDataConnectionWWAN,
	BMFDataConnectionWiFi
};

@protocol BMFDataConnectionCheckerProtocol <NSObject>

- (BOOL) dataConnectionAvailable;

- (BMFDataConnectionKind) dataConnectionKind;


@end
