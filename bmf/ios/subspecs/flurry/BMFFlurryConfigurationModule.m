//
//  BMFFlurryConfigurationModule.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFFlurryConfigurationModule.h"

#import "BMFTypes.h"

//#import <FlurrySDK/Flurry.h>
#import "BMFFlurryLogger.h"

@implementation BMFFlurryConfigurationModule

- (instancetype) initWithApiKey:(NSString *) apiKey {
	BMFAssertReturnNil(apiKey.length>0);
	
	self = [super init];
	if (self) {
		_apiKey = apiKey;
	}
	
	return self;
}

- (BOOL) setup {
	
	id logger = [BMFFlurryLogger sharedInstance];
	if (logger) [DDLog addLogger:logger withLevel:DDLogLevelInfo];
		
	Class flurryClass = NSClassFromString(@"Flurry");
	if (flurryClass) {
		SEL setApiKeySelector = sel_registerName("startSession:");
		
		BMFSuppressPerformSelectorLeakWarning(
											  [flurryClass performSelector:setApiKeySelector withObject:_apiKey];
											  );
	}
	else {
		DDLogError(@"ERROR: Flurry not included in the project!");
	}
	
	return YES;
}

- (void) tearDown {
}

@end
