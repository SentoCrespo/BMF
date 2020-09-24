//
//  TRNLogUtils.m
//  geofence
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/09/14.
//  Copyright (c) 2014 Treenovum. All rights reserved.
//

#import "BMFLogUtils.h"

#import <BMF/BMFEmailActivity.h>

@implementation BMFLogUtils

+ (NSString *) logString {
	NSMutableString *result = [NSMutableString string];
	
	DDFileLogger *fileLogger = [self activeFileLogger];
	NSArray *filePaths = [self logFilePathsForLogger:fileLogger];

	for (NSString *filePath in [filePaths reverseObjectEnumerator]) {
		[result appendString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]];
	}
	
	return result;
}

+ (DDFileLogger *) activeFileLogger {
	DDFileLogger *fileLogger = nil;
	
	NSArray *loggers = [DDLog allLoggers];
	for (DDAbstractLogger *logger in loggers) {
		fileLogger = [DDFileLogger BMF_cast:logger];
		if (fileLogger) break;
	}
	
	return fileLogger;
}

+ (NSArray *) logFilePathsForLogger:(DDFileLogger *) fileLogger {
	NSMutableArray *results = [NSMutableArray array];
	
	NSArray *sortedLogFileInfos = [fileLogger.logFileManager sortedLogFileInfos];
	
	sortedLogFileInfos = [[sortedLogFileInfos reverseObjectEnumerator] allObjects];
	
	for (NSUInteger i = 0; i < MIN(sortedLogFileInfos.count, fileLogger.logFileManager.maximumNumberOfLogFiles); i++) {
		DDLogFileInfo *logFileInfo = sortedLogFileInfos[i];
		
		[results addObject:logFileInfo.filePath];
	}
	
	return results;
}

+ (void) clearLog:(BMFBlock) completionBlock {
	DDFileLogger *fileLogger = [self activeFileLogger];
	[self deleteLogFiles];
	[fileLogger rollLogFileWithCompletionBlock:completionBlock];
}

+ (void) deleteLogFiles {
	DDFileLogger *fileLogger = [self activeFileLogger];
	NSArray *filePaths = [self logFilePathsForLogger:fileLogger];
	for (NSString *filePath in filePaths) {
		[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
	}
}

+ (void)emailData:(id)sender otherFilePaths:(NSArray *)otherFilePaths completion:(BMFCompletionBlock) completionBlock {
	
	DDFileLogger *fileLogger = [BMFLogUtils activeFileLogger];
	NSArray *filePaths = [BMFLogUtils logFilePathsForLogger:fileLogger];
	
	NSMutableArray *fileUrls = [NSMutableArray array];
	for (NSString *filePath in filePaths) {
		[fileUrls addObject:[NSURL fileURLWithPath:filePath]];
	}
	
	for (NSString *otherFile in otherFilePaths) {
		[fileUrls addObject:[NSURL fileURLWithPath:otherFile]];
	}
	
	BMFEmailActivity *emailActivity = [[BMFEmailActivity alloc] initWithViewController:sender];
	emailActivity.subject = NSLocalizedString(@"Logs", nil);
	emailActivity.attachedFileUrls = fileUrls;

#if TARGET_OS_IPHONE
	emailActivity.viewController = sender;
#endif
	
	[emailActivity run:completionBlock];
}


@end
