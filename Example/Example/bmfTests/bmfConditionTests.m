//
//  bmfConditionTests.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "BMFCondition.h"
#import "BMFBlockCondition.h"
#import "BMFSystemVersionCondition.h"

#import "BMFConditionalValue.h"

#import "BMFDevice.h"

SpecBegin(Conditions)

describe(@"BMFBlockCondition", ^{
	
	it(@"should return correct value", ^{
		
		BMFBlockCondition *blockCondition = [[BMFBlockCondition alloc] initWithBlock:^BOOL(id p){
			return YES;
		}];
		
		expect([blockCondition evaluate]).to.beTruthy();
		
		blockCondition.block = ^BOOL(id p){ return NO; };
		
		expect([blockCondition evaluate]).to.beFalsy();
	});
});

describe(@"BMFSystemVersionCondition", ^{
	
	it(@"should evaluate correctly for a lesser version", ^{
		id mock = [OCMockObject mockForClass:[BMFDevice class]];
		[[[[mock stub] classMethod] andReturn:@"7.0"] currentSystemVersion];
		
		BMFSystemVersionCondition *condition = [[BMFSystemVersionCondition alloc] initWithSystemVersion:@"6.1" comparisonType:BMFConditionLessThanOrEqualComparisonType];
		
		expect([condition evaluate]).to.beTruthy();

		condition.comparisonType = BMFConditionLessThanComparisonType;
		expect([condition evaluate]).to.beTruthy();

		condition.comparisonType = BMFConditionEqualComparisonType;
		expect([condition evaluate]).to.beFalsy();

		condition.comparisonType = BMFConditionGreaterThanOrEqualComparisonType;
		expect([condition evaluate]).to.beFalsy();

		condition.comparisonType = BMFConditionGreaterThanComparisonType;
		expect([condition evaluate]).to.beFalsy();

		condition.comparisonType = BMFConditionDifferentComparisonType;
		expect([condition evaluate]).to.beTruthy();
	});
	
	it(@"should evaluate correctly for the same version", ^{
		id mock = [OCMockObject mockForClass:[BMFDevice class]];
		[[[[mock stub] classMethod] andReturn:@"7.0"] currentSystemVersion];
		
		BMFSystemVersionCondition *condition = [[BMFSystemVersionCondition alloc] initWithSystemVersion:@"7.0" comparisonType:BMFConditionLessThanOrEqualComparisonType];
		
		expect([condition evaluate]).to.beTruthy();
		
		condition.comparisonType = BMFConditionLessThanComparisonType;
		expect([condition evaluate]).to.beFalsy();
		
		condition.comparisonType = BMFConditionEqualComparisonType;
		expect([condition evaluate]).to.beTruthy();
		
		condition.comparisonType = BMFConditionGreaterThanOrEqualComparisonType;
		expect([condition evaluate]).to.beTruthy();
		
		condition.comparisonType = BMFConditionGreaterThanComparisonType;
		expect([condition evaluate]).to.beFalsy();
		
		condition.comparisonType = BMFConditionDifferentComparisonType;
		expect([condition evaluate]).to.beFalsy();
	});
	
	it(@"should evaluate correctly for the a greater version", ^{
		id mock = [OCMockObject mockForClass:[BMFDevice class]];
		[[[[mock stub] classMethod] andReturn:@"7.0"] currentSystemVersion];
		
		BMFSystemVersionCondition *condition = [[BMFSystemVersionCondition alloc] initWithSystemVersion:@"7.1" comparisonType:BMFConditionLessThanOrEqualComparisonType];
		
		expect([condition evaluate]).to.beFalsy();
		
		condition.comparisonType = BMFConditionLessThanComparisonType;
		expect([condition evaluate]).to.beFalsy();
		
		condition.comparisonType = BMFConditionEqualComparisonType;
		expect([condition evaluate]).to.beFalsy();
		
		condition.comparisonType = BMFConditionGreaterThanOrEqualComparisonType;
		expect([condition evaluate]).to.beTruthy();
		
		condition.comparisonType = BMFConditionGreaterThanComparisonType;
		expect([condition evaluate]).to.beTruthy();
		
		condition.comparisonType = BMFConditionDifferentComparisonType;
		expect([condition evaluate]).to.beTruthy();
	});
	
});

describe(@"BMFConditionalValue", ^{
	
	it(@"should allow nil value", ^{
		BMFConditionalValue *conditionalValue = [[BMFConditionalValue alloc] initWithDefaultValue:nil];
		
		expect(conditionalValue).notTo.beNil();
		expect([conditionalValue currentValue]).to.beNil();
		
		[conditionalValue addValue:nil conditions:@[ [BMFTrueCondition new] ]];
		
		expect([conditionalValue currentValue]).to.beNil();		
	});
	
	it(@"should convert nsnull to nil", ^{
		BMFConditionalValue *conditionalValue = [[BMFConditionalValue alloc] initWithDefaultValue:[NSNull null]];
		
		expect(conditionalValue).notTo.beNil();
		expect([conditionalValue currentValue]).to.beNil();
		
		[conditionalValue addValue:nil conditions:@[ [BMFTrueCondition new] ]];
		
		expect([conditionalValue currentValue]).to.beNil();
	});
	
	it(@"should return default value if no conditions matched and allrequiredmode used", ^{
		BMFConditionalValue *conditionalValue = [[BMFConditionalValue alloc] initWithDefaultValue:@33];

		expect([conditionalValue currentValue]).to.equal(@33);
		
		[conditionalValue addValue:@11 conditions:@[ [BMFTrueCondition new], [BMFFalseCondition new] ]];
		
		expect([conditionalValue currentValue]).to.equal(@33);
	});
	
	it(@"should return correct value if all conditions matched", ^{
		BMFConditionalValue *conditionalValue = [[BMFConditionalValue alloc] initWithDefaultValue:@33];
		
		expect([conditionalValue currentValue]).to.equal(@33);
		
		[conditionalValue addValue:@11 conditions:@[ [BMFTrueCondition new],[BMFTrueCondition new] ]];
		
		expect([conditionalValue currentValue]).to.equal(@11);
	});
	
	it(@"should return correct value if some conditions matched and bestmatchmode used", ^{
		BMFConditionalValue *conditionalValue = [[BMFConditionalValue alloc] initWithDefaultValue:@33];
		conditionalValue.mode = BMFConditionalValueBestMatchMode;
		
		[conditionalValue addValue:@11 conditions:@[ [BMFTrueCondition new],[BMFFalseCondition new] ]];
		
		expect([conditionalValue currentValue]).to.equal(@11);
	});
	
	it(@"should return correct value between multiple options with allrequiredmode", ^{
		BMFConditionalValue *conditionalValue = [[BMFConditionalValue alloc] initWithDefaultValue:@33];
		
		[conditionalValue addValue:@11 conditions:@[ [BMFTrueCondition new] ]];

		expect([conditionalValue currentValue]).to.equal(@11);
		
		[conditionalValue addValue:@44 conditions:@[ [BMFFalseCondition new],[BMFTrueCondition new] ]];
		
		expect([conditionalValue currentValue]).to.equal(@11);
		
		[conditionalValue addValue:@22 conditions:@[ [BMFTrueCondition new],[BMFTrueCondition new] ]];
		
		expect([conditionalValue currentValue]).to.equal(@22);
	});
	
	it(@"should return correct value between multiple options with bestmatchmode", ^{
		BMFConditionalValue *conditionalValue = [[BMFConditionalValue alloc] initWithDefaultValue:@33];
		
		conditionalValue.mode = BMFConditionalValueBestMatchMode;
		
		[conditionalValue addValue:@11 conditions:@[ [BMFTrueCondition new] ]];
		
		expect([conditionalValue currentValue]).to.equal(@11);
		
		[conditionalValue addValue:@22 conditions:@[ [BMFFalseCondition new],[BMFTrueCondition new],[BMFTrueCondition new] ]];
		
		expect([conditionalValue currentValue]).to.equal(@22);
	});

	
	it(@"should return correct value with priorities between multiple options with allrequiredmode", ^{
		BMFConditionalValue *conditionalValue = [[BMFConditionalValue alloc] initWithDefaultValue:@33];
		
		[conditionalValue addValue:@11 conditions:@[ [BMFTrueCondition new] ] priority:3];
		
		expect([conditionalValue currentValue]).to.equal(@11);
		
		[conditionalValue addValue:@22 conditions:@[ [BMFTrueCondition new],[BMFTrueCondition new] ]];
		
		expect([conditionalValue currentValue]).to.equal(@11);
	});

	it(@"should return correct value with priorities between multiple options with bestmatchmode", ^{
		BMFConditionalValue *conditionalValue = [[BMFConditionalValue alloc] initWithDefaultValue:@33];
		conditionalValue.mode = BMFConditionalValueBestMatchMode;

		[conditionalValue addValue:@11 conditions:@[ [BMFTrueCondition new] ] priority:2];
		
		expect([conditionalValue currentValue]).to.equal(@11);
		
		[conditionalValue addValue:@22 conditions:@[ [BMFFalseCondition new],[BMFTrueCondition new] ] priority:3];
		
		expect([conditionalValue currentValue]).to.equal(@22);
	});

	
});

SpecEnd