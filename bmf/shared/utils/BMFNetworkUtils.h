//
//  BMFNetworkUtils.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 19/2/15.
//
//

#import <Foundation/Foundation.h>

@interface BMFNetworkInfo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *bssid;

- (instancetype) initWithDictionary:(NSDictionary *) infoDic;

@end

@interface BMFNetworkUtils : NSObject

+ (BMFNetworkInfo *) currentNetworkInfo;

@end
