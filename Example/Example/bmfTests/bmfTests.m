//
//  bmfTests.m
//  bmfTests
//
//  Created by Jose Manuel Sánchez Peñarroja on 08/01/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSString+BMF.h"

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "BMFCondition.h"

#import "BMFWeakObject.h"
#import "BMFMutableWeakArray.h"
#import "BMFMutableWeakDictionary.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


SpecBegin(BasicTests)

describe(@"BMFMutableWeakArray", ^{
	
	/*it(@"should store values while retained", ^AsyncBlock{
		BMFMutableWeakArray *weakArray = [BMFMutableWeakArray new];
		id value1 = [[NSNumber alloc] initWithInt:1];

		[weakArray addObject:value1];
		
		BMFWeakObject *weakObj = [[BMFWeakObject alloc] initWithObject:value1];
		[[RACObserve(weakObj, object) filter:^BOOL(id value) {
			return (value==nil);
		}] subscribeNext:^(id x) {
			expect(weakArray.count).to.equal(0);
			done();
		}];
		
	});
	*/
	
	/*it(@"should store values while retained", ^AsyncBlock{

		BMFMutableWeakArray *weakArray = [BMFMutableWeakArray new];
		
		id value1 = [[NSNumber alloc] initWithInt:1];
		
		[weakArray addObject:value1];
		
		
		
		[[value1 rac_signalForSelector:NSSelectorFromString(@"dealloc")] subscribeNext:^(id x) {
			expect(weakArray.count).to.equal(0);
			
			done();
		}];
		*/
		
		/*BMFMutableWeakArray *weakArray = [BMFMutableWeakArray new];
		
		id value1 = [[NSNumber alloc] initWithInt:1];
		__block id value2 = [[NSNumber alloc] initWithInt:2];
		__block id value3 = [[NSNumber alloc] initWithInt:3];
		__block id value4 = [[NSNumber alloc] initWithInt:4];
		
		__weak NSNumber *val1 = value1;
		__weak NSNumber *val2 = value2;
		__weak NSNumber *val3 = value3;
		__weak NSNumber *val4 = value4;
		
//		[weakArray addObject:value1];
//		[weakArray addObject:value2];
//		[weakArray addObject:value3];
//		[weakArray addObject:value4];
		
//		expect(weakArray.count).to.equal(4);
//		
//		expect(weakArray[0]).to.equal(value1);
//		expect(weakArray[1]).to.equal(value2);
//		expect(weakArray[2]).to.equal(value3);
//		expect(weakArray[3]).to.equal(value4);

		value1 = nil;
		value2 = nil;
		value3 = nil;
		value4 = nil;
		
		dispatch_async(dispatch_get_global_queue(0, 0), ^{
			dispatch_async(dispatch_get_main_queue(), ^{
				expect(val1).to.beNil();
				expect(val2).to.beNil();
				expect(val3).to.beNil();
				expect(val4).to.beNil();
//				expect(weakArray.count).to.equal(3);
//				expect(weakArray[0]).to.equal(value2);
//				expect(weakArray[1]).to.equal(value3);
//				expect(weakArray[2]).to.equal(value4);
//				
//				value2 = nil;
//				expect(val2).to.beNil();
//				
//				expect(weakArray.count).to.equal(2);
//				expect(weakArray[0]).to.equal(value3);
//				expect(weakArray[1]).to.equal(value4);
//				
//				value3 = nil;
//				expect(val3).to.beNil();
//				
//				expect(weakArray.count).to.equal(1);
//				expect(weakArray[0]).to.equal(value4);
//				
//				value4 = nil;
//				expect(val4).to.beNil();
//				
//				expect(weakArray.count).to.equal(0);
				
				done();
			});
		});*/
//	});
});

SpecEnd
