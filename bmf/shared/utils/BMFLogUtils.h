//
//  TRNLogUtils.h
//  geofence
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/09/14.
//  Copyright (c) 2014 Treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"

@class DDFileLogger;

@interface BMFLogUtils : NSObject

+ (NSString *) logString;
+ (void) clearLog:(BMFBlock) completionBlock;

+ (DDFileLogger *) activeFileLogger;
+ (NSArray *) logFilePathsForLogger:(DDFileLogger *) fileLogger;
+ (void)emailData:(id)sender otherFilePaths:(NSArray *)otherFilePaths completion:(BMFCompletionBlock) completionBlock;

@end
