//
//  BMFCheckUrlSizeLoader.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 27/3/15.
//
//

#import <Foundation/Foundation.h>

#import "BMFLoaderProtocol.h"

@interface BMFCheckUrlSizeLoader : NSObject <BMFLoaderProtocol>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, readonly) BMFProgress *progress;

@end
