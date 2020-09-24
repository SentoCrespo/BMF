//
//  BMFFMDBModelProtocol.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 05/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;

@protocol BMFFMDBModelProtocol <NSObject>

+ (instancetype) BMF_entityWithSet:(FMResultSet *) set;

@optional
+ (instancetype) BMF_entityWithSet:(FMResultSet *) set parameters:(NSDictionary *)parameters;

@end
