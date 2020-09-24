//
//  bmfThrottleAspectTest.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 03/07/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import <BMF/BMFThrottleAspect.h>

SpecBegin(ThrottleAspect)

describe(@"BMFThrottleAspect", ^{
	
	it(@"check initialization parameters", ^{
		__block BMFThrottleAspect *aspect = nil;
		
		expect(^{ aspect = [[BMFThrottleAspect alloc] initWithInterval:-1 actionBlock:^(id sender) {} identifier:@"blah"]; }).to.raiseAny();
		expect(aspect).to.beNil();
		expect(^{ aspect = [[BMFThrottleAspect alloc] initWithInterval:0 actionBlock:^(id sender) {} identifier:@"blah"]; }).to.raiseAny();
		expect(aspect).to.beNil();
		expect(^{ aspect = [[BMFThrottleAspect alloc] initWithInterval:10 actionBlock:nil identifier:@"blah"]; }).to.raiseAny();
		expect(aspect).to.beNil();
		expect(^{ aspect = [[BMFThrottleAspect alloc] initWithInterval:10 actionBlock:^(id sender) {} identifier:nil]; }).to.raiseAny();
		expect(aspect).to.beNil();
		expect(^{ aspect = [[BMFThrottleAspect alloc] initWithInterval:10 actionBlock:^(id sender) {} identifier:@""]; }).to.raiseAny();
		expect(aspect).to.beNil();
		expect(^{ aspect = [[BMFThrottleAspect alloc] initWithInterval:10 actionBlock:^(id sender) {} identifier:@"blah"]; }).toNot.raiseAny();
		
		expect(aspect).notTo.beNil();
		expect(^{ aspect.minimumTimeInterval = 0; }).to.raiseAny();
		expect(^{ aspect.actionBlock = nil; }).to.raiseAny();
		expect(^{ aspect.identifier = nil; }).to.raiseAny();
		expect(^{ aspect.identifier = @""; }).to.raiseAny();
	});
	
	it(@"shouldn't call before the minimum time interval", ^AsyncBlock {
		__block NSDate *date = nil;
		BMFThrottleAspect *aspect = [[BMFThrottleAspect alloc] initWithInterval:1 actionBlock:^(id sender) {
			NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
			expect(interval).to.beGreaterThanOrEqualTo(1);
			
			[aspect stop];
			done();
		} identifier:@"tests"];
		
		[aspect clear];
		
		date = [NSDate date];
		DDLogInfo(@"start date: %@",[NSDate date]);
		[aspect start];
	});
	
	it(@"shouldn't call before the minimum time interval if we set a tolerance", ^AsyncBlock{
		__block NSDate *date = nil;
		BMFThrottleAspect *aspect = [[BMFThrottleAspect alloc] initWithInterval:1 actionBlock:^(id sender) {
			NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
			expect(interval).to.beGreaterThanOrEqualTo(1);
			
			[aspect stop];
			done();
		} identifier:@"tests"];
		
		aspect.tolerance = 1;
		[aspect clear];
		
		date = [NSDate date];
		[aspect start];

	});
	
	it(@"should allow changing the minimum time interval", ^AsyncBlock{
		__block NSDate *date = nil;
		BMFThrottleAspect *aspect = [[BMFThrottleAspect alloc] initWithInterval:1 actionBlock:^(id sender) {
			NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
			expect(interval).to.beGreaterThanOrEqualTo(2);
			
			[aspect stop];
			done();
		} identifier:@"tests"];
		
		aspect.minimumTimeInterval = 2;
		[aspect clear];
		
		date = [NSDate date];
		[aspect start];
	});
});


SpecEnd
