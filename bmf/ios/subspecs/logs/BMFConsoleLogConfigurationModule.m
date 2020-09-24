//
//  BMFConsoleLogConfigurationModule.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/09/14.
//
//

#import "BMFConsoleLogConfigurationModule.h"

#import <JMSLogger/JMSLogger.h>

@implementation BMFConsoleLogConfigurationModule

- (BOOL) setup {
	
	[DDLog addLogger:[JMSLogger new] withLevel:DDLogLevelAll];
	
	return YES;
}

- (void) tearDown {
}

@end
