//
//  BMFFlurryConfigurationModule.h
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFConfigurationProtocol.h"

@interface BMFFlurryConfigurationModule : NSObject <BMFConfigurationProtocol>

@property (nonatomic, strong) NSString *apiKey;

- (instancetype) initWithApiKey:(NSString *) apiKey;
- (instancetype) init __attribute__((unavailable("Use initWithApiKey: instead")));

@end
