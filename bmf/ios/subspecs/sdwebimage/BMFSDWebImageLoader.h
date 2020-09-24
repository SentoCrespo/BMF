//
//  BMFSDWebImageLoader.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/06/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFLoaderProtocol.h"

#import <SDWebImage/SDWebImageManager.h>

@interface BMFSDWebImageLoader : NSObject <BMFLoaderProtocol>

@property (nonatomic, readonly) BMFProgress *progress;

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, assign) SDWebImageOptions options;

@end
