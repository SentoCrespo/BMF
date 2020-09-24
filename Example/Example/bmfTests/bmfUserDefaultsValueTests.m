//
//  bmfUserDefaultsValueTests.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/07/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import <BMF/BMFUserDefaultsValue.h>

SpecBegin(BMFUserDefaultsValue)

describe(@"BMFUserDefaultsValue", ^{
	
	it(@"should require a valid id", ^{
		
		__block BMFUserDefaultsValue *userDefaultsValue = nil;
		
		expect(^{ userDefaultsValue = [BMFUserDefaultsValue new]; }).to.raiseAny();
		expect(userDefaultsValue).to.beNil();
		expect(^{ userDefaultsValue = [[BMFUserDefaultsValue alloc] initWithId:nil]; }).to.raiseAny();
		expect(userDefaultsValue).to.beNil();
		expect(^{ userDefaultsValue = [[BMFUserDefaultsValue alloc] initWithId:@"blah"]; }).notTo.raiseAny();
		expect(userDefaultsValue).notTo.beNil();
	});
	
	it(@"should save and load values correctly", ^{
		
		__block BMFUserDefaultsValue *userDefaultsValue = nil;
		
		expect(^{ userDefaultsValue = [[BMFUserDefaultsValue alloc] initWithId:@"blah"]; }).notTo.raiseAny();
		expect(userDefaultsValue).notTo.beNil();
		
		[userDefaultsValue setCurrentValue:@55];
		expect([userDefaultsValue currentValue]).to.equal(@55);

		[userDefaultsValue setCurrentValue:@44];
		expect([userDefaultsValue currentValue]).to.equal(@44);

		[userDefaultsValue setCurrentValue:nil];
		expect([userDefaultsValue currentValue]).to.beNil();
	});
	
	it(@"should persist values", ^{
		
		__block BMFUserDefaultsValue *userDefaultsValue = nil;
		
		expect(^{ userDefaultsValue = [[BMFUserDefaultsValue alloc] initWithId:@"blah"]; }).notTo.raiseAny();
		expect(userDefaultsValue).notTo.beNil();
		
		[userDefaultsValue setCurrentValue:@55];
		expect([userDefaultsValue currentValue]).to.equal(@55);

		expect(^{ userDefaultsValue = [[BMFUserDefaultsValue alloc] initWithId:@"blah"]; }).notTo.raiseAny();
		expect(userDefaultsValue).notTo.beNil();

		expect([userDefaultsValue currentValue]).to.equal(@55);
	});
	
	it(@"should call applyValueBlock when changing value", ^ {
		
		__block BMFUserDefaultsValue *userDefaultsValue = nil;

		expect(^{ userDefaultsValue = [[BMFUserDefaultsValue alloc] initWithId:@"blah"]; }).notTo.raiseAny();
		
		__block NSInteger calledTimes = 0;

		__block id correctValue = @33;
		[userDefaultsValue setCurrentValue:@33];
		
		userDefaultsValue.applyValueBlock = ^(id<BMFValueProtocol> value) {
			DDLogInfo(@"value: %@",[value currentValue]);
			expect([value currentValue]).to.equal(correctValue);
			calledTimes++;
		};
		
		correctValue = @55;
		[userDefaultsValue setCurrentValue:@55];
		
		/// This should be 2. It's called when assigning the block and then when changing the value
		expect(calledTimes).to.equal(2);
	});
	
	it(@"should save and load date values correctly", ^{

		__block BMFUserDefaultsValue *userDefaultsValue = nil;
		
		expect(^{ userDefaultsValue = [[BMFUserDefaultsValue alloc] initWithId:@"blah"]; }).notTo.raiseAny();
		expect(userDefaultsValue).notTo.beNil();
		
		NSDate *date = [NSDate date];
		[userDefaultsValue setCurrentValue:date];
		expect([userDefaultsValue currentValue]).to.equal(date);
	});
});


SpecEnd