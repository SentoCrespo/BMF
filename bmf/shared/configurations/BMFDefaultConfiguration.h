//
//  BMFDefaultConfiguration.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/01/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFConfiguration.h"

@interface BMFDefaultConfiguration : BMFConfiguration

@property (nonatomic, assign) BOOL useCoreData; // NO by default
@property (nonatomic, assign) BOOL setupSharedCache; // YES by default

@property (nonatomic, assign) int cacheMemorySize;
@property (nonatomic, assign) int cacheDiskSize;

@end
