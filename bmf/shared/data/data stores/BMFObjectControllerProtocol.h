//
//  BMFObjectStoreProtocol.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/05/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFObjectDataStore.h"

@protocol BMFObjectControllerProtocol <NSObject>

@property (nonatomic, strong) BMFObjectDataStore *objectStore;

@end
