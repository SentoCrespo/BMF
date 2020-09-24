//
//  BMFConsoleLogUtils.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/09/14.
//
//

#import "BMFConsoleLogUtils.h"

#import "BMF.h"

@implementation BMFConsoleLogUtils

+ (NSString *) logLevelStringForLogLevel: (NSInteger) logLevel {
	if (logLevel==DDLogLevelError) {
		return BMFLocalized(@"Error", nil);
	}
	else if (logLevel==DDLogLevelWarning) {
		return BMFLocalized(@"Warning", nil);
	}
	else if (logLevel==DDLogLevelInfo) {
		return BMFLocalized(@"Information", nil);
	}
	else if (logLevel==DDLogLevelDebug) {
		return BMFLocalized(@"Debug", nil);
	}
	else if (logLevel==DDLogLevelVerbose) {
		return BMFLocalized(@"Verbose", nil);
	}
	else {
		return BMFLocalized(@"Unknown", nil);
	}
}

+ (UIColor *) colorForLogLevel:(NSInteger) logLevel {
	if (logLevel==DDLogLevelError) {
		return [UIColor redColor];
	}
	else if (logLevel==DDLogLevelWarning) {
		return [UIColor orangeColor];
	}
	
	return [UIColor blackColor];
}

+ (NSString *) contextStringForContext: (NSInteger) context {
	if (context==BMFLogGlobalContext) {
		return BMFLocalized(@"Global",nil);
	}
	else if (context==BMFLogCoreContext) {
		return BMFLocalized(@"Core",nil);
	}
    else if (context==BMFLogNetworkContext) {
		return BMFLocalized(@"Network",nil);
	}
    else if (context==BMFLogBehaviorContext) {
		return BMFLocalized(@"Behavior",nil);
	}
	else if (context==BMFLogUIContext) {
		return BMFLocalized(@"UI",nil);
	}
	else if (context==BMFLogAppContext) {
		return BMFLocalized(@"App",nil);
	}
	else return BMFLocalized(@"Unknown",nil);
}

@end
