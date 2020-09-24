//
//  bmfSettingsTests.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 16/09/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import <BMF/BMFSetting.h>
#import <BMF/BMFBooleanSetting.h>
#import <BMF/BMFNumberSetting.h>
#import <BMF/BMFRangeValueSetting.h>
#import <BMF/BMFStringSetting.h>
#import <BMF/BMFUrlSetting.h>
#import <BMF/BMFSettingsManager.h>

#import <BMF/BMFFileLoader.h>
#import <BMF/BMFLoaderOperation.h>
#import <BMF/BMFJSONSerializer.h>
#import <BMF/BMFSerializerOperation.h>
#import <BMF/BMFOperationsTask.h>

void loadSettings(NSBundle *bundle,NSString *fileName,NSString *extension,BMFCompletionBlock completionBlock) {
	NSURL *settingsUrl = [bundle URLForResource:fileName withExtension:extension];
	BMFFileLoader *loader = [BMFFileLoader new];
	loader.fileUrl = settingsUrl;
	
	[loader load:completionBlock];
}

SharedExamplesBegin(Settings)

sharedExamplesFor(@"Settings shared behavior", ^(NSDictionary *data) {
	it(@"shouldn't allow a nil key", ^{
		Class settingClass = data[@"settingClass"];

		__block id<BMFSettingProtocol> setting = nil;
		expect(^{ setting = [[settingClass alloc] init]; }).to.raiseAny();
		expect(setting).to.beNil();
		
		setting = [[settingClass alloc] initWithKey:@"myBool"];
		expect(setting).notTo.beNil();
		
		expect(^{ [setting setKey:nil]; }).to.raiseAny();
		expect(^{ [setting setKey:@""]; }).to.raiseAny();
	});
});

SharedExamplesEnd

SpecBegin(Setting)

describe(@"BMFBooleanSetting", ^{
	
	__block id userDefaultsMock = nil;
	
	beforeAll(^{
		userDefaultsMock = OCMClassMock([NSUserDefaults class]);
		OCMStub([userDefaultsMock standardUserDefaults]).andReturn(userDefaultsMock);
	});
	
	itShouldBehaveLike(@"Settings shared behavior", @{@"settingClass" : [BMFBooleanSetting class] });
//	
//	it(@"shouldn't allow a nil key",^{
//		__block BMFBooleanSetting *setting = nil;
//		expect(^{ setting = [[BMFBooleanSetting alloc] init]; }).to.raiseAny();
//		expect(setting).to.beNil();
//		
//		setting = [[BMFBooleanSetting alloc] initWithKey:@"myBool"];
//		expect(setting).notTo.beNil();
//		
//		expect(^{ [setting setKey:nil]; }).to.raiseAny();
//		expect(^{ [setting setKey:@""]; }).to.raiseAny();
//	});
	
	it(@"should return the default value if no value set", ^{
		NSString *key = @"myBool";
		__block BMFBooleanSetting *setting = [[BMFBooleanSetting alloc] initWithKey:key];
		setting.defaultValue = @NO;
		setting.userDefaults = userDefaultsMock;
		
		expect(setting.currentValue).notTo.beNil();
		expect(setting.currentValue).to.beKindOf([NSNumber class]);
		expect([setting.currentValue boolValue]).to.beFalsy();
		
		setting.defaultValue = @YES;
		expect([setting.currentValue boolValue]).to.beTruthy();
	});
	
	it(@"should return the correct value if set",^{
		NSString *key = @"myBool";
		__block BMFBooleanSetting *setting = [[BMFBooleanSetting alloc] initWithKey:key];
		setting.defaultValue = @NO;
		setting.userDefaults = userDefaultsMock;

		OCMStub([userDefaultsMock valueForKey:key]).andReturn(@YES);
		
		setting.currentValue = @YES;
		expect([setting.currentValue boolValue]).to.beTruthy();
		
		OCMVerify([userDefaultsMock setValue:@YES forKey:key]);
	});
	
});

describe(@"BMFRangeValueSetting", ^{
	
	__block id userDefaultsMock = nil;
	
	beforeAll(^{
		userDefaultsMock = OCMClassMock([NSUserDefaults class]);
		OCMStub([userDefaultsMock standardUserDefaults]).andReturn(userDefaultsMock);
	});
	
	
	itShouldBehaveLike(@"Settings shared behavior", @{@"settingClass" : [BMFRangeValueSetting class] });

	it(@"should return the correct value if set",^{
		NSString *key = @"myRangeValue";
		__block BMFRangeValueSetting *setting = [[BMFRangeValueSetting alloc] initWithKey:key];
		setting.defaultValue = @5;
		setting.minValue = @1;
		setting.maxValue = @50;
		setting.userDefaults = userDefaultsMock;
		
		OCMStub([userDefaultsMock valueForKey:key]).andReturn(@10);
		
		setting.currentValue = @10;
		expect(setting.currentValue).to.equal(10);
		
		OCMVerify([userDefaultsMock setValue:@10 forKey:key]);
	});
	
	it(@"shouldn't allow values outside range",^{
		NSString *key = @"otherRangeValue";
		__block BMFRangeValueSetting *setting = [[BMFRangeValueSetting alloc] initWithKey:key];
		setting.defaultValue = @5;
		setting.minValue = @1;
		setting.maxValue = @50;
		setting.userDefaults = userDefaultsMock;
		
		OCMStub([userDefaultsMock valueForKey:key]).andReturn(@5);
		
		setting.currentValue = @100;
		expect(setting.currentValue).to.equal(5);
	});
});

describe(@"BMFSettingsManager", ^{
	
	__block id userDefaultsMock = nil;
	
	beforeAll(^{
		userDefaultsMock = OCMClassMock([NSUserDefaults class]);
		OCMStub([userDefaultsMock standardUserDefaults]).andReturn(userDefaultsMock);
	});
	
	it(@"shoud load correctly settings from a file",^AsyncBlock{
		
		loadSettings([NSBundle bundleForClass:[self class]],@"settings",@"json",^(id result,NSError *error) {
			expect(result).notTo.beNil();
			expect(error).to.beNil();
			
			BMFSettingsManager *settingsManager = [BMFSettingsManager new];
			
			settingsManager.userDefaults = userDefaultsMock;
			
			[settingsManager loadFromData:result completion:^(id result, NSError *error) {

				expect(error).to.beNil();
				expect(result).to.beKindOf([NSDictionary class]);
				NSDictionary *settingsDic = result;
				expect(settingsDic.allKeys.count).to.equal(5);
				
				BMFBooleanSetting *boolSetting = [settingsManager settingWithKey:@"BoolSetting"];
				expect(boolSetting).notTo.beNil();
				expect(boolSetting).to.beKindOf([BMFBooleanSetting class]);
				expect([boolSetting key]).to.equal(@"BoolSetting");
				expect([boolSetting defaultValue]).to.equal(YES);
				expect([boolSetting currentValue]).to.equal(YES);
				
				
				BMFNumberSetting *numberSetting = [settingsManager settingWithKey:@"NumberSetting"];
				expect(numberSetting).notTo.beNil();
				expect(numberSetting).to.beKindOf([BMFNumberSetting class]);
				expect([numberSetting key]).to.equal(@"NumberSetting");
				expect([numberSetting defaultValue]).to.equal(10);
				expect([numberSetting currentValue]).to.equal(10);

				BMFRangeValueSetting *rangeValueSetting = [settingsManager settingWithKey:@"RangeValueSetting"];
				expect(rangeValueSetting).notTo.beNil();
				expect(rangeValueSetting).to.beKindOf([BMFRangeValueSetting class]);
				expect([rangeValueSetting key]).to.equal(@"RangeValueSetting");
				expect([rangeValueSetting defaultValue]).to.equal(@10);
				expect([rangeValueSetting currentValue]).to.equal(@10);
				expect([rangeValueSetting minValue]).to.equal(@5);
				expect([rangeValueSetting maxValue]).to.equal(@50);
				
				BMFStringSetting *stringSetting = [settingsManager settingWithKey:@"StringSetting"];
				expect(stringSetting).notTo.beNil();
				expect(stringSetting).to.beKindOf([BMFStringSetting class]);
				expect([stringSetting key]).to.equal(@"StringSetting");
				expect([stringSetting defaultValue]).to.equal(@"blah");
				expect([stringSetting currentValue]).to.equal(@"blah");
				
				NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
				
				BMFUrlSetting *urlSetting = [settingsManager settingWithKey:@"UrlSetting"];
				expect(urlSetting).notTo.beNil();
				expect(urlSetting).to.beKindOf([BMFUrlSetting class]);
				expect([urlSetting key]).to.equal(@"UrlSetting");
				expect([urlSetting defaultValue]).notTo.beNil();
				expect([urlSetting defaultValue]).to.equal(url);
				expect([urlSetting currentValue]).to.equal(url);
				
				OCMVerify([userDefaultsMock registerDefaults:OCMOCK_ANY]);
				
				done();
			}];
			
		});
	});
	
	it(@"should correctly override defaults but not values", ^AsyncBlock {
		loadSettings([NSBundle bundleForClass:[self class]],@"settings",@"json",^(id result,NSError *error) {
			expect(result).notTo.beNil();
			expect(error).to.beNil();
		
			BMFSettingsManager *settingsManager = [BMFSettingsManager new];
			
			settingsManager.userDefaults = userDefaultsMock;
			
			[settingsManager loadFromData:result completion:^(id result, NSError *error) {
				
				BMFBooleanSetting *boolSetting = [settingsManager settingWithKey:@"BoolSetting"];
				boolSetting.currentValue = @NO;
				
				BMFRangeValueSetting *rangeValueSetting = [settingsManager settingWithKey:@"RangeValueSetting"];
				rangeValueSetting.currentValue = @22;
				
				BMFStringSetting *stringSetting = [settingsManager settingWithKey:@"StringSetting"];
				stringSetting.currentValue  = @"bloh";
				
				BMFUrlSetting *urlSetting = [settingsManager settingWithKey:@"UrlSetting"];
				urlSetting.currentValue = @"http://yahoo.com";
				
				OCMVerify([userDefaultsMock setValue:@NO forKey:@"BoolSetting"]);
				OCMVerify([userDefaultsMock setValue:@22 forKey:@"RangeValueSetting"]);
				OCMVerify([userDefaultsMock setValue:@"bloh" forKey:@"StringSetting"]);
				OCMVerify([userDefaultsMock setValue:[NSURL URLWithString:@"http://yahoo.com"] forKey:@"UrlSetting"]);
				
				loadSettings([NSBundle bundleForClass:[self class]],@"settings2",@"json",^(id result,NSError *error) {
					expect(result).notTo.beNil();
					expect(error).to.beNil();
					
					[settingsManager loadFromData:result completion:^(id result, NSError *error) {
						
						OCMStub([userDefaultsMock valueForKey:@"BoolSetting"]).andReturn(@NO);
						OCMStub([userDefaultsMock valueForKey:@"RangeValueSetting"]).andReturn(@22);
						OCMStub([userDefaultsMock valueForKey:@"StringSetting"]).andReturn(@"bloh");
						NSURL *yahooUrl = [NSURL URLWithString:@"http://yahoo.com"];
						OCMStub([userDefaultsMock valueForKey:@"UrlSetting"]).andReturn(yahooUrl);
						
						BMFBooleanSetting *boolSetting = [settingsManager settingWithKey:@"BoolSetting"];
						expect(boolSetting.defaultValue).to.equal(NO);
						expect(boolSetting.currentValue).to.equal(NO);
						
						BMFRangeValueSetting *rangeValueSetting = [settingsManager settingWithKey:@"RangeValueSetting"];
						expect(rangeValueSetting.minValue).to.equal(1);
						expect(rangeValueSetting.maxValue).to.equal(70);
						expect(rangeValueSetting.defaultValue).to.equal(30);
						expect(rangeValueSetting.currentValue).to.equal(22);
						
						BMFStringSetting *stringSetting = [settingsManager settingWithKey:@"StringSetting"];
						expect(stringSetting.defaultValue).to.equal(@"blih");
						expect(stringSetting.currentValue).to.equal(@"bloh");
						
						BMFUrlSetting *urlSetting = [settingsManager settingWithKey:@"UrlSetting"];
						expect(urlSetting.defaultValue).to.equal([NSURL URLWithString:@"http://www.apple.com"]);
						expect(urlSetting.currentValue).to.equal(yahooUrl);
						
						done();
					}];

				});
							 
			}];
		});
	});
});


SpecEnd
