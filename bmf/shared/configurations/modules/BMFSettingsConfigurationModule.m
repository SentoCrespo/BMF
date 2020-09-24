//
//  BMFSettingsConfigurationModule.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/10/14.
//
//

#import "BMFSettingsConfigurationModule.h"

#import "BMF.h"

#import "BMFSettingsManager.h"

#import "BMFObserverAspect.h"

#import "BMFFileUpdater.h"

/// 10 minutes between settings updates
BMFLocalConstant(NSTimeInterval, BMFMinimumUpdateInterval, 60*10);

@interface BMFSettingsConfigurationModule()

@property (nonatomic, strong) BMFSettingsManager *settingsManager;
@property (nonatomic, strong) BMFFileUpdater *fileUpdater;

@end

@implementation BMFSettingsConfigurationModule

- (instancetype)init
{
	self = [super init];
	if (self) {
		_localSettingsUrl = [[NSBundle mainBundle] URLForResource:@"settings" withExtension:@"json"];
		_settingsManager = [BMFSettingsManager new];
	}
	return self;
}

- (NSURL *) localCachedSettingsUrl {
	return [NSURL fileURLWithPath:[[[BMFUtils applicationDocumentsDirectory] stringByAppendingPathComponent:@"bmf"] stringByAppendingPathComponent:@"settings.json"]];
}

- (BOOL) setup {
	[BMFBase sharedInstance].settingsManager = self.settingsManager;
	
	self.fileUpdater = [[BMFFileUpdater alloc] initWithLocalFileUrl:[self localCachedSettingsUrl]];
	self.fileUpdater.remoteUrl = self.remoteSettingsUrl;
	
	self.fileUpdater.resourceFileUrl = self.localSettingsUrl;
	
	self.fileUpdater.validator = self.settingsManager;
	
	[self loadSettings];
	
	BMFObserverAspect *foregroundObserver = [[BMFObserverAspect alloc] initWithName:BMFApplicationWillEnterForegroundNotification block:^(id sender) {
		if (fabs([self.fileUpdater.lastUpdatedDate timeIntervalSinceNow])>BMFMinimumUpdateInterval) {
			[self updateSettings];
		}
	}];
	[self BMF_addAspect:foregroundObserver];
	
	return YES;
}

- (void) loadSettings {
	[self.fileUpdater load:^(id result, NSError *error) {
		if (result) {
			[self.settingsManager loadFromData:result completion:^(id result, NSError *error) {
				if (result) {
					[self updateSettings];
				}
				else {
					DDLogError(@"Error loading settings: %@",error);
				}
			}];
		}
	}];

}

- (void) updateSettings {
	if (!self.fileUpdater.remoteUrl) return;
	
	[self.fileUpdater update:^(id result, NSError *error) {
		if (result) {
			[self.settingsManager loadFromData:result completion:^(id result, NSError *error) {
				if (!result) {
					DDLogError(@"Error updating settings: %@",error);
				}
			}];
		}
		else {
			DDLogError(@"Error loading settings for update: %@",error);
		}
	}];
}

- (void) tearDown {
}

@end
