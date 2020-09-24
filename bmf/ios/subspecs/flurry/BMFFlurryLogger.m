//
//  BMFFlurryLumberjack.m
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 17/01/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import "BMFFlurryLogger.h"

@implementation BMFFlurryLogger

-(void) logMessage:(DDLogMessage *)logMessage
{
    NSString *logMsg = logMessage->_message;
    
    if (_logFormatter)
    {
        logMsg = [_logFormatter formatLogMessage:logMessage];
    }
    
    if (logMsg) {
		
		Class flurryClass = NSClassFromString(@"Flurry");
		if (flurryClass) {
			SEL logEventSelector = sel_registerName("logEvent:");
			BMFSuppressPerformSelectorLeakWarning([flurryClass performSelector:logEventSelector withObject:logMsg]);
		}
    }
}


+(BMFFlurryLogger*) sharedInstance {
    static dispatch_once_t pred = 0;
    static BMFFlurryLogger *_sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

@end
