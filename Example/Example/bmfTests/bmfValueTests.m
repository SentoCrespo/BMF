//
//  bmfValueArrayTests.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <XCTest/XCTest.h>


#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "BMF.h"

#import "BMFUtils.h"
#import "BMFFixedValue.h"
#import "BMFBlockValue.h"
#import "BMFValueArray.h"
#import "BMFFixedValueChooser.h"
#import "BMFRoundRobinValueChooser.h"
#import "BMFAverageValue.h"

SpecBegin(BMFBlockValue)

describe(@"BMFFixedValue", ^{
	__block BMFFixedValue *fixedValue;
	
	it(@"shouldn't raise for empty values", ^{
		expect(^{ fixedValue = [[BMFFixedValue alloc] init]; }).notTo.raiseAny();
		expect(fixedValue).notTo.beNil();
		expect(^{ fixedValue = [[BMFFixedValue alloc] initWithValue:nil]; }).notTo.raiseAny();
		expect(fixedValue).notTo.beNil();
		expect(^{ [fixedValue setValue:nil];}).notTo.raiseAny();

		expect([fixedValue currentValue]).to.beNil();
	});
	
	it(@"should allow nsnull and convert it to nil", ^{
		fixedValue = [[BMFFixedValue alloc] initWithValue:[NSNull null]];
		expect([fixedValue currentValue]).to.beNil();
	});
	
	it(@"Should unbox current value", ^{
		BMFFixedValue *innerValue = [[BMFFixedValue alloc] initWithValue:@5];
		
		fixedValue = [[BMFFixedValue alloc] initWithValue:innerValue];
		
		expect([fixedValue currentValue]).to.equal(@5);
	});
	
	it(@"Should apply it's value when setting it", ^{
		fixedValue = [[BMFFixedValue alloc] initWithValue:@5];
		
		__block NSNumber *numberValue = nil;
		fixedValue.signalBlock = ^(NSNumber *value) {
			numberValue = value;
		};
		
		expect(numberValue).to.equal(@5);
	});
	
	it(@"Should apply it's value if the block changes", ^{
		fixedValue = [[BMFFixedValue alloc] initWithValue:nil];
		
		__block NSNumber *numberValue = nil;
		fixedValue.signalBlock = ^(NSNumber *value) {
			numberValue = value;
		};
		
		expect(numberValue).to.beNil();
		
		[fixedValue setValue:@5];
		
		expect(numberValue).to.equal(@5);
	});
	
	it(@"Shouldn't call apply block if the value is the same", ^{
		fixedValue = [[BMFFixedValue alloc] initWithValue:@33];

		__block int numCalled = 0;
		
		fixedValue.signalBlock = ^(NSNumber *value) {
			numCalled++;
		};
		
		[fixedValue setCurrentValue:@33];
		[fixedValue setCurrentValue:@33];
		[fixedValue setCurrentValue:@33];
		
		/// It is called once when the block is set, then it shouldn't be called anymore
		expect(numCalled).to.equal(1);
	});
});

describe(@"BMFBlockValue",^{
	__block BMFBlockValue *blockValue;
	
	it(@"shouldn't allow empty values",^{
		expect(^{ blockValue = [[BMFBlockValue alloc] init]; }).to.raiseAny();
		expect(blockValue).to.beNil();

		expect(^{ blockValue = [[BMFBlockValue alloc] initWithBlock:nil]; }).to.raiseAny();
		expect(blockValue).to.beNil();
		
		blockValue = [[BMFBlockValue alloc] initWithBlock:^id(){ return nil; }];
		expect(blockValue).notTo.beNil();
		
		expect(^{ blockValue.valueBlock = nil; }).to.raiseAny();
		expect(blockValue).notTo.beNil();
	});
	
	it(@"should allow nsnull and convert it to nil", ^{
		blockValue = [[BMFBlockValue alloc] initWithBlock:^id(){ return [NSNull null]; }];
		expect([blockValue currentValue]).to.beNil();
	});
	
	it(@"Should unbox current value", ^{
		BMFFixedValue *fixedValue = [[BMFFixedValue alloc] initWithValue:@5];
		
		blockValue = [[BMFBlockValue alloc] initWithBlock:^id{
			return fixedValue;
		}];
		
		expect(blockValue).notTo.beNil();
		
		expect([blockValue currentValue]).to.equal(@5);
	});

	it(@"Should apply it's value when setting it", ^{
		blockValue = [[BMFBlockValue alloc] initWithBlock:^id(){ return @5; }];

		__block NSNumber *numberValue = nil;
		
		blockValue.signalBlock = ^(NSNumber *value) {
			numberValue = value;
		};
		
		expect(numberValue).to.equal(@5);
	});
	
	it(@"Should apply it's value if the block changes", ^{
		blockValue = [[BMFBlockValue alloc] initWithBlock:^id(){ return nil; }];
		
		__block NSNumber *numberValue = nil;
		blockValue.signalBlock = ^(NSNumber *value) {
			numberValue = value;
		};
	
		expect(numberValue).to.beNil();
		
		[blockValue setValueBlock:^id(){
			return @5;
		}];
		
		expect(numberValue).to.equal(@5);
	});
});

SpecEnd

SpecBegin(BMFValueArray)

describe(@"BMFValueArray", ^{
	__block BMFValueArray *valueArray;

	it(@"shouldn't allow empty values",^{
		expect(^{ valueArray = [BMFValueArray new]; }).to.raiseAny();
		expect(valueArray).to.beNil();
		expect(^{ valueArray = [[BMFValueArray alloc] init]; }).to.raiseAny();
		expect(valueArray).to.beNil();
		expect(^{ valueArray = [[BMFValueArray alloc] initWithValues:nil]; }).to.raiseAny();
		expect(valueArray).to.beNil();
		expect(^{ valueArray = [[BMFValueArray alloc] initWithValues:@[]]; }).to.raiseAny();
		expect(valueArray).to.beNil();
		
		valueArray = [[BMFValueArray alloc] initWithValues:@[ @"First", @"Second" ]];
		expect(valueArray).notTo.beNil();
		
		expect(^{ valueArray.values = nil; }).to.raiseAny();
		expect(valueArray).notTo.beNil();
		
		expect(^{ valueArray.values = @[]; }).to.raiseAny();
		expect(valueArray).notTo.beNil();
	});
	
	it(@"should allow nsnull and convert it to nil", ^{
		
		valueArray = [[BMFValueArray alloc] initWithValues:@[ [NSNull null] ]];
		expect(valueArray).notTo.beNil();
		
		expect([valueArray currentValue]).to.beNil();
	});
	
});

describe(@"BMFRoundRobinValueChooser", ^{

	__block NSArray *values;
	__block BMFValueArray *valueArray;
	
	beforeEach(^{
		values = @[ @"First", @"Second" ];
		valueArray = [[BMFValueArray alloc] initWithValues:values];
	});
	
	it(@"should cycle correctly", ^{
		valueArray.valueChooser = [BMFRoundRobinValueChooser new];
		expect(valueArray.currentValue).to.equal(values[0]);
		
		[valueArray.valueChooser nextValue];
		expect(valueArray.currentValue).to.equal(values[1]);

		[valueArray.valueChooser nextValue];
		expect(valueArray.currentValue).to.equal(values[0]);
	});
	
	
	it(@"should allow to change values on the fly", ^{
		valueArray.valueChooser = [BMFRoundRobinValueChooser new];
		expect(valueArray.currentValue).to.equal(values[0]);
		
		[valueArray.valueChooser nextValue];

		NSArray *shorter = @[ @"First" ];
		valueArray.values = shorter;
		expect(valueArray.currentValue).to.equal(shorter.firstObject);

		[valueArray.valueChooser nextValue];
		expect(valueArray.currentValue).to.equal(shorter.firstObject);
	});
	
});

describe(@"BMFAverageValue", ^{
	__block BMFAverageValue *averageValue;
	
	it(@"should allow init with nil", ^{
		expect(^{ averageValue = [[BMFAverageValue alloc] init]; }).notTo.raiseAny();
		expect([averageValue defaultValue]).to.beNil();
		expect([averageValue currentValue]).to.beNil();

		expect(^{ averageValue = [[BMFAverageValue alloc] initWithDefaultValue:nil]; }).notTo.raiseAny();
		expect([averageValue defaultValue]).to.beNil();
		expect([averageValue currentValue]).to.beNil();
	});
	
	it(@"should return the default values if no values added",^{
		averageValue = [[BMFAverageValue alloc] initWithDefaultValue:@33];
		expect([averageValue currentValue]).to.equal(@33);
		
		averageValue.defaultValue = @44;
		expect([averageValue currentValue]).to.equal(@44);
	});

	it(@"should throw if tried to add a nil value",^{
		averageValue = [[BMFAverageValue alloc] initWithDefaultValue:@33];
		
		expect(^{ [averageValue addValue:nil]; }).to.raiseAny();
	});

	it(@"should throw if tried to remove a value where there is none",^{
		averageValue = [[BMFAverageValue alloc] initWithDefaultValue:@33];
		
		expect(^{ [averageValue removeValue:@10]; }).to.raiseAny();
	});

	it(@"should return the 1st value if only one added",^{
		averageValue = [[BMFAverageValue alloc] initWithDefaultValue:@33];
		
		[averageValue addValue:@10];
		expect(averageValue.currentValue).to.equal(@10);
	});
	
	it(@"should average values correctly",^{
		averageValue = [[BMFAverageValue alloc] initWithDefaultValue:@33];
		
		[averageValue addValue:@10];
		[averageValue addValue:@30];
		
		expect(averageValue.currentValue).to.equal(@20);
	});
	
	it(@"should average values correctly when removing values",^{
		averageValue = [[BMFAverageValue alloc] initWithDefaultValue:@33];
		
		[averageValue addValue:@10];
		[averageValue addValue:@30];
		
		[averageValue removeValue:@10];
		expect(averageValue.currentValue).to.equal(@30);

		[averageValue removeValue:@30];
		expect(averageValue.currentValue).to.equal(@33);
		
	});
	
	it(@"should correctly ponderate the average if set",^{
		double ponderation = 1.2;
		averageValue = [[BMFAverageValue alloc] initWithDefaultValue:@33];
		averageValue.ponderation = ponderation;

		[averageValue addValue:@10];
		[averageValue addValue:@30];
		expect(averageValue.currentValue).to.equal( @(((2-ponderation)*10+ponderation*30)/2) );
	});
});

SpecEnd
