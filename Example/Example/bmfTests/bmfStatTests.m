//
//  bmfStatTests.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import <BMF/BMFAverageStats.h>
#import <BMF/BMFUtils.h>

static NSURL *statsFileUrl = nil;
static BMFAverageStats *stats = nil;

SpecBegin(Stats)

describe(@"BMFAverageStats", ^{
	
	beforeAll(^{
		statsFileUrl = [NSURL fileURLWithPath:[[BMFUtils applicationCacheDirectory] stringByAppendingPathComponent:@"com.bmfTests"]];
		stats = [[BMFAverageStats alloc] initWithFileUrl:statsFileUrl];
		[stats removeAllValues];
	});
	
	beforeEach(^{
		stats = [[BMFAverageStats alloc] initWithFileUrl:statsFileUrl];
		[stats removeAllValues];
	});

	it(@"should return -DBL_MAX if no default values and no value added", ^{
		
		stats = nil;
		
		expect(^{ stats = [[BMFAverageStats alloc] init]; }).to.raiseAny();
		expect(stats).to.beNil();
		expect(^{ stats = [[BMFAverageStats alloc] initWithFileUrl:nil]; }).to.raiseAny();
		expect(stats).to.beNil();
		
		stats = [BMFAverageStats globalStats];
		expect(stats).notTo.beNil();
		
		stats = [[BMFAverageStats alloc] initWithFileUrl:statsFileUrl];
		expect(stats).notTo.beNil();
		
		expect([stats averageValueForKey:@"blah"]).to.equal(-DBL_MAX);
	});
	
	it(@"should use the default value if no values added", ^{
				
		expect(stats).notTo.beNil();

		[stats setDefaultValue:5 forKey:@"blah"];
		expect([stats averageValueForKey:@"blah"]).to.equal(5);
	});
	
	it(@"should use the added value if only one", ^{
				
		[stats addValue:5 forKey:@"blah"];
		expect([stats averageValueForKey:@"blah"]).to.equal(5);
	});
	
	it(@"should clear values correctly", ^{
		[stats addValue:5 forKey:@"blah"];
		expect([stats averageValueForKey:@"blah"]).to.equal(5);

		[stats removeAllValuesForKey:@"blah"];
		expect([stats averageValueForKey:@"blah"]).to.equal(-DBL_MAX);
	});
	
	it(@"should correctly average values", ^{
		
		[stats removeAllValuesForKey:@"blah"];
				
		[stats addValue:10 forKey:@"blah"];
		[stats addValue:20 forKey:@"blah"];
		[stats addValue:30 forKey:@"blah"];
		
		expect([stats averageValueForKey:@"blah"]).to.equal(20);
	});
	
	it(@"should keep values when deleted and created again", ^{
		[stats addValue:10 forKey:@"blah"];
		[stats addValue:20 forKey:@"blah"];
		[stats addValue:30 forKey:@"blah"];
		
		stats = nil;
		
		stats = [[BMFAverageStats alloc] initWithFileUrl:statsFileUrl];
		
		expect([stats averageValueForKey:@"blah"]).to.equal(20);
	});
});


SpecEnd