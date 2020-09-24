//
//  BMFDefaultConfiguration.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/01/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFDefaultConfiguration.h"

#import <CocoaLumberjack/DDTTYLogger.h>
#import <CocoaLumberjack/DDASLLogger.h>

#import "BMFUrlCacheConfigurationModule.h"

#import "BMFTypes.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BMFDefaultConfiguration()

@property (nonatomic, strong) BMFUrlCacheConfigurationModule *cacheModule;

@end

@implementation BMFDefaultConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.setupSharedCache = NO;
    }
    return self;
}

- (void) setCacheDiskSize:(int)cacheDiskSize {
	[self.cacheModule setCacheDiskSize:cacheDiskSize];
}

- (int) cacheDiskSize {
	return [self.cacheModule cacheDiskSize];
}

- (void) setCacheMemorySize:(int)cacheMemorySize {
	[self.cacheModule setCacheMemorySize:cacheMemorySize];
}

- (int) cacheMemorySize {
	return [self.cacheModule cacheMemorySize];
}

- (void) setUseCoreData:(BOOL)useCoreData {
	_useCoreData = useCoreData;
	if (_useCoreData) {
		Class mrModule = NSClassFromString(@"BMFMagicalRecordConfigurationModule");
		SEL initSelector = NSSelectorFromString(@"init");
		BMFSuppressPerformSelectorLeakWarning(
											  [self addModule:[[mrModule alloc] performSelector:initSelector withObject:nil]];
											  );

	}
}

- (BOOL) setup {
	[DDLog addLogger:[DDASLLogger sharedInstance]];
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
	DDFileLogger *fileLogger = [DDFileLogger new];
	
	fileLogger.logFileManager.maximumNumberOfLogFiles = 2;
	[DDLog addLogger:fileLogger withLevel:DDLogLevelDebug];
	
	if (self.setupSharedCache) {
		self.cacheModule = [BMFUrlCacheConfigurationModule new];
		[self addModule:self.cacheModule];
	}
	
	[super setup];
	
	return YES;
}

- (void) tearDown {
	[super tearDown];
}

@end
