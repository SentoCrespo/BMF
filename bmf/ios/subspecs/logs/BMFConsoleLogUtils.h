//
//  BMFConsoleLogUtils.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/09/14.
//
//

#import <Foundation/Foundation.h>

@interface BMFConsoleLogUtils : NSObject

+ (NSString *) logLevelStringForLogLevel: (NSInteger) logLevel;
+ (UIColor *) colorForLogLevel:(NSInteger) logLevel;
+ (NSString *) contextStringForContext: (NSInteger) context;

@end
