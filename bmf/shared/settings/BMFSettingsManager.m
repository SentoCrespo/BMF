//
//  BMFSettingsManager.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/9/14.
//
//

#import "BMFSettingsManager.h"

#import "BMF.h"

#import "BMFBooleanSetting.h"
#import "BMFNumberSetting.h"
#import "BMFRangeValueSetting.h"
#import "BMFStringSetting.h"
#import "BMFUrlSetting.h"

#import <ReactiveCocoa/RACEXTScope.h>

BMFLocalConstant(NSString *, BMFBooleanSettingType, @"bool");
BMFLocalConstant(NSString *, BMFNumberSettingType, @"number");
BMFLocalConstant(NSString *, BMFRangeValueSettingType, @"rangeValue");
BMFLocalConstant(NSString *, BMFStringSettingType, @"string");
BMFLocalConstant(NSString *, BMFUrlSettingType, @"url");

@implementation BMFSettingsManager

- (instancetype)init
{
	self = [super init];
	if (self) {
		
		_userDefaults = [NSUserDefaults standardUserDefaults];
		
		@weakify(self);
		[RACObserve(self, settingsDic) subscribeNext:^(id x) {
			@strongify(self);
			[self registerSettings];
		}];
	}
	return self;
}

#pragma mark BMFSettingsManagerProtocol

- (id<BMFSettingProtocol>) settingWithKey:(NSString *) key {
	return self.settingsDic[key];
}

- (NSArray *) allSettings {
	return [self.settingsDic allValues];
}

- (NSArray *) userAdjustableSettings {
	NSMutableArray *settings = [NSMutableArray array];
	for (BMFSetting *setting in [self allSettings]) {
		if (setting.userAdjustable) [settings addObject:setting];
	}
	return settings;
}

- (NSURL *) localFileUrl {
	return [NSURL fileURLWithPath:[[[BMFUtils applicationDocumentsDirectory] stringByAppendingPathComponent:@"bmf"] stringByAppendingPathComponent:@"settings.json"]];
}

- (void) loadFromData:(NSData *)data completion:(BMFCompletionBlock) completionBlock {
	BMFAssertReturn(data);
	BMFAssertReturn(completionBlock);

	id<BMFSerializerProtocol> serializer = [[BMFBase sharedInstance].factory jsonSerializer:self];
	[serializer parse:data completion:^(id result, NSError *error) {
		BMFAssertReturn([result isKindOfClass:[NSDictionary class]]);
		
		self.settingsDic = [self loadFromRawDictionary:result];
		
		completionBlock(self.settingsDic,nil);
	}];
}

- (NSDictionary *) loadFromRawDictionary:(NSDictionary *) rawDictionary {
	NSMutableDictionary *newSettingsDic = [NSMutableDictionary dictionary];
	
	for (NSString *key in [rawDictionary allKeys]) {
		NSDictionary *settingDic = rawDictionary[key];
		id<BMFSettingProtocol> setting = [self loadFromDictionary:settingDic key:key];
		if (setting) {
			newSettingsDic[key] = setting;
		}
		else {
			BMFLogWarnC(BMFLogCoreContext,@"Couldn't load setting from dictionary: %@",settingDic);
			return nil;
		}
	}
	
	return newSettingsDic;
}

- (void) registerSettings {
	
	NSMutableDictionary *defaultsDic = [NSMutableDictionary dictionary];
	
	for (NSString *key in self.settingsDic.allKeys) {
		id<BMFSettingProtocol> setting = self.settingsDic[key];
		id defaultValue = setting.defaultRawValue;
		if (defaultValue) defaultsDic[key] = defaultValue;
	}
	
	[self.userDefaults registerDefaults:defaultsDic];
}

- (id<BMFSettingProtocol>) loadFromDictionary:(NSDictionary *) dic key:(NSString *)key {
	NSString *settingType = dic[@"type"];
	
	id<BMFSettingProtocol> result = nil;
	
	if (settingType.length==0) {
		BMFLogErrorC(BMFLogCoreContext,@"Error loading setting from dictionary: no type: %@",dic);
		return nil;
	}
	
	if (key.length==0) {
		BMFLogErrorC(BMFLogCoreContext,@"Error loading setting from dictionary: no key: %@",dic);
		return nil;
	}
	
	if ([settingType isEqualToString:BMFBooleanSettingType]) {
		result = [[BMFBooleanSetting alloc] initWithKey:key];
	}
	else if ([settingType isEqualToString:BMFNumberSettingType]) {
		result = [[BMFNumberSetting alloc] initWithKey:key];
	}
	else if ([settingType isEqualToString:BMFRangeValueSettingType]) {
		result = [[BMFRangeValueSetting alloc] initWithKey:key];
	}
	else if ([settingType isEqualToString:BMFStringSettingType]) {
		result = [[BMFStringSetting alloc] initWithKey:key];
	}
	else if ([settingType isEqualToString:BMFUrlSettingType]) {
		result = [[BMFUrlSetting alloc] initWithKey:key];
	}
	else {
		BMFLogErrorC(BMFLogCoreContext,@"Error loading setting from dictionary: unknown type: %@",dic);
	}
	
	result.name = dic[@"name"];
	
	NSNumber *userAdjustableNumber = dic[@"userAdjustable"];
	if ([userAdjustableNumber isKindOfClass:[NSNumber class]]) {
		result.userAdjustable = [userAdjustableNumber boolValue];
		
		if (result.userAdjustable && result.name.length==0) {
			BMFLogErrorC(BMFLogCoreContext,@"Name is required if the setting is user adjustable: %@",dic);
			return nil;
		}
	}
	
	[result loadFromDictionary:dic];
	result.userDefaults = self.userDefaults;
	
	return result;
}

#pragma mark BMFValidatorProtocol

- (BOOL) validate:(id) value {
	if (![value isKindOfClass:[NSData class]]) return NO;
	
	NSDictionary *object = [NSJSONSerialization JSONObjectWithData:value options:NSJSONReadingAllowFragments error:nil];
	if (!object || ![object isKindOfClass:[NSDictionary class]]) return NO;
	
	NSDictionary *settings = [self loadFromRawDictionary:object];

	return (settings!=nil);
}

@end
