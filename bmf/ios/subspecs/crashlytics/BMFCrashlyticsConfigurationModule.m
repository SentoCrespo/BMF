//
//  BMFCrashlyticsConfigurationModule.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFCrashlyticsConfigurationModule.h"

#import "BMFTypes.h"

#import <CrashlyticsLumberjack/CrashlyticsLogger.h>

@implementation BMFCrashlyticsConfigurationModule

- (instancetype) initWithApiKey:(NSString *) apiKey {
	BMFAssertReturnNil(apiKey.length>0);
	
	self = [super init];
	if (self) {
		_apiKey = apiKey;
	}
	
	return self;
}

- (BOOL) setup {
	
	if (_apiKey.length==0) {
		DDLogWarn(@"No api key specified");
		return NO;
	}
	
	id CrashlyticsLoggerClass = NSClassFromString(@"CrashlyticsLogger");
	if (CrashlyticsLoggerClass) {
		id logger = [CrashlyticsLogger sharedInstance];
		if (logger) [DDLog addLogger:logger withLevel:DDLogLevelDebug];
	}
	
	Class crashlyticsClass = NSClassFromString(@"Crashlytics");
	if (crashlyticsClass) {
		SEL setApiKeySelector = sel_registerName("startWithAPIKey:");
		
		BMFSuppressPerformSelectorLeakWarning(
										   [crashlyticsClass performSelector:setApiKeySelector withObject:_apiKey];
										   );
	}
	else {
		DDLogError(@"ERROR: Crashlytics not included in the project!");
	}
	
	return YES;
}

- (void) tearDown {
}


@end
