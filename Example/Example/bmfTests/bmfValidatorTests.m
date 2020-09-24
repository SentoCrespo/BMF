//
//  bmfValidatorTests.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/07/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import <BMF/BMFBlockValidator.h>
#import <BMF/BMFObjectClassValidator.h>
#import <BMF/BMFRangeValueValidator.h>

SpecBegin(Validator)

describe(@"BMFBlockValidator", ^{
	
	it(@"should require a block", ^{
		__block BMFBlockValidator *validator = nil;
		expect(^{ validator = [BMFBlockValidator new]; }).to.raiseAny();
		expect(validator).to.beNil();
		expect(^{ validator = [[BMFBlockValidator alloc] init]; }).to.raiseAny();
		expect(validator).to.beNil();
		expect(^{ validator = [[BMFBlockValidator alloc] initWithBlock:nil]; }).to.raiseAny();
		expect(validator).to.beNil();
		validator = [[BMFBlockValidator alloc] initWithBlock:^BOOL(id value) {
			return NO;
		}];
		expect(validator).notTo.beNil();
		expect(^{ validator.block = nil; }).to.raiseAny();
	});
	
	it(@"should validate correctly", ^{
		BMFBlockValidator *validator = [[BMFBlockValidator alloc] initWithBlock:^BOOL(NSNumber *value) {
			return value.integerValue<50;
		}];
		
		expect([validator validate:@51]).to.beFalsy();
		expect([validator validate:@49]).to.beTruthy();
	});
});

describe(@"BMFObjectClassValidator", ^{
	
	it(@"should require valid object class", ^{
		__block BMFObjectClassValidator *validator = nil;
		expect(^{ validator = [BMFObjectClassValidator new]; }).to.raiseAny();
		expect(validator).to.beNil();
		expect(^{ validator = [[BMFObjectClassValidator alloc] init]; }).to.raiseAny();
		expect(validator).to.beNil();
		expect(^{ validator = [[BMFObjectClassValidator alloc] initWithClass:nil]; }).to.raiseAny();
		expect(validator).to.beNil();
		validator = [[BMFObjectClassValidator alloc] initWithClass:[NSString class]];
		expect(validator).notTo.beNil();
		expect(^{ validator.validObjectClass = nil; }).to.raiseAny();
	});
	
	it(@"should validate correctly", ^{
		BMFObjectClassValidator *validator = [[BMFObjectClassValidator alloc] initWithClass:[NSString class]];
		
		expect([validator validate:@"blah"]).to.beTruthy();
		expect([validator validate:@1]).to.beFalsy();
	});
});

describe(@"BMFRangeValueValidator", ^{
	
	it(@"should require min or max value on validation", ^{
		__block BMFRangeValueValidator *validator = nil;
		expect(^{ validator = [BMFRangeValueValidator new]; }).notTo.raiseAny();
		expect(validator).notTo.beNil();
		
		expect(^{ [validator validate:@22]; }).to.raiseAny();
		
		validator.minValue = @2;
		expect(^{ [validator validate:@22]; }).notTo.raiseAny();
		
		validator.maxValue = @30;
		validator.minValue = nil;
		expect(^{ [validator validate:@22]; }).notTo.raiseAny();
		
		validator.maxValue = nil;
		expect(^{ [validator validate:@22]; }).to.raiseAny();
	});
	
	it(@"should validate correctly", ^{
		BMFRangeValueValidator *validator = [[BMFRangeValueValidator alloc] initWithMinValue:@2 maxValue:@10];
		
		expect([validator validate:@1]).to.beFalsy();
		expect([validator validate:@2]).to.beTruthy();
		expect([validator validate:@5]).to.beTruthy();
		expect([validator validate:@10]).to.beTruthy();
		expect([validator validate:@11]).to.beFalsy();
	});
});

SpecEnd
