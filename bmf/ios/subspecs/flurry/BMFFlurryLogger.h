//
//  BMFFlurryLumberjack.h
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 17/01/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"

@interface BMFFlurryLogger : DDAbstractLogger

+ (BMFFlurryLogger*) sharedInstance;

@end
