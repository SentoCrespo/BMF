//
//  BMFBaseCellConfigurator.h
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 02/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFRegistrableProtocol.h"
#import "BMFViewConfiguratorProtocol.h"

@interface BMFViewConfigurator : NSObject <BMFRegistrableProtocol>

+ (NSArray *) registeredClasses;

/// configuratorClass should conform to protocol BMFCellConfiguratorProtocol
+ (void) register;
+ (void) unregister;

+ (Class<BMFViewConfiguratorProtocol>) configuratorForView:(id) view kind:(NSString *)kind item:(id) item inView:(id)containerView;

@end
