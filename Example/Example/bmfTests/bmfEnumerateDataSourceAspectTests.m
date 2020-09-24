//
//  bmfEnumerateDataSourceAspectTests.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/06/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "BMF.h"

#import "BMFDataSourceProtocol.h"
#import "BMFEnumerateDataSourceAspect.h"
#import "BMFArrayDataStore.h"

#import "BMFCompoundDataStore.h"

SpecBegin(EnumerateDataSourceAspect)

describe(@"empty store", ^{
	
	it(@"should return error when enumerating forward",^{
		id<BMFDataReadProtocol> dataStore = [[BMFArrayDataStore alloc] init];
		id dataSource = [OCMockObject mockForProtocol:@protocol(BMFDataSourceProtocol)];
		[[[dataSource stub] andReturn:dataStore] dataStore];

		BMFEnumerateDataSourceAspect *aspect = [[BMFEnumerateDataSourceAspect alloc] init];
		[aspect setObject:dataSource];
		
		expect(aspect.indexPath.row).to.equal(0);
		expect(aspect.indexPath.section).to.equal(0);
		
		[aspect action:nil completion:^(id result, NSError *error) {
			expect(error).toNot.beNil();
			expect(result).to.beNil();
		}];
	});
	
	it(@"should return error when enumerating backward",^{
		id<BMFDataReadProtocol> dataStore = [[BMFArrayDataStore alloc] init];
		id dataSource = [OCMockObject mockForProtocol:@protocol(BMFDataSourceProtocol)];
		[[[dataSource stub] andReturn:dataStore] dataStore];
		
		BMFEnumerateDataSourceAspect *aspect = [[BMFEnumerateDataSourceAspect alloc] init];
		aspect.mode = BMFEnumerateDataSourceAspectModeBackward;
		[aspect setObject:dataSource];
		
		expect(aspect.indexPath.row).to.equal(0);
		expect(aspect.indexPath.section).to.equal(0);
		
		[aspect action:nil completion:^(id result, NSError *error) {
			expect(error).toNot.beNil();
			expect(result).to.beNil();
		}];
	});
});

describe(@"1 section store", ^{
	it(@"should correctly enumerate forward",^{
		BMFArrayDataStore *dataStore = [[BMFArrayDataStore alloc] init];
		dataStore.items = @[ @1,@2,@3,@4 ];
		
		id dataSource = [OCMockObject mockForProtocol:@protocol(BMFDataSourceProtocol)];
		[[[dataSource stub] andReturn:dataStore] dataStore];
		
		BMFEnumerateDataSourceAspect *aspect = [[BMFEnumerateDataSourceAspect alloc] init];
		[aspect setObject:dataSource];
		
		expect(aspect.mode).to.equal(BMFEnumerateDataSourceAspectModeForward);
		
		expect(aspect.indexPath.row).to.equal(0);
		expect(aspect.indexPath.section).to.equal(0);
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(1);
			expect([dataStore itemAt:result]).to.equal(@2);
			expect(result.section).to.equal(0);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(2);
			expect([dataStore itemAt:result]).to.equal(@3);
			expect(result.section).to.equal(0);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(3);
			expect([dataStore itemAt:result]).to.equal(@4);
			expect(result.section).to.equal(0);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(0);
			expect([dataStore itemAt:result]).to.equal(@1);
			expect(result.section).to.equal(0);
		}];
	});
	
	it(@"should correctly enumerate backward",^{
		BMFArrayDataStore *dataStore = [[BMFArrayDataStore alloc] init];
		dataStore.items = @[ @1,@2,@3,@4];
		
		id dataSource = [OCMockObject mockForProtocol:@protocol(BMFDataSourceProtocol)];
		[[[dataSource stub] andReturn:dataStore] dataStore];
		
		BMFEnumerateDataSourceAspect *aspect = [[BMFEnumerateDataSourceAspect alloc] init];
		aspect.mode = BMFEnumerateDataSourceAspectModeBackward;

		[aspect setObject:dataSource];
		
		expect(aspect.mode).to.equal(BMFEnumerateDataSourceAspectModeBackward);
		
		expect(aspect.indexPath.row).to.equal(0);
		expect(aspect.indexPath.section).to.equal(0);
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(3);
			expect([dataStore itemAt:result]).to.equal(@4);
			expect(result.section).to.equal(0);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(2);
			expect([dataStore itemAt:result]).to.equal(@3);
			expect(result.section).to.equal(0);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(1);
			expect([dataStore itemAt:result]).to.equal(@2);
			expect(result.section).to.equal(0);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(0);
			expect([dataStore itemAt:result]).to.equal(@1);
			expect(result.section).to.equal(0);
		}];
	});

});

describe(@"Multiple sections store", ^{
	it(@"should correctly enumerate forward",^{
		BMFArrayDataStore *dataStore1 = [[BMFArrayDataStore alloc] init];
		dataStore1.items = @[ @1,@2 ];

		BMFArrayDataStore *dataStore2 = [[BMFArrayDataStore alloc] init];
		dataStore2.items = @[ @3 ];

		BMFArrayDataStore *dataStore3 = [[BMFArrayDataStore alloc] init];
		dataStore3.items = @[ @4, @5  ];

		
		BMFCompoundDataStore *dataStore = [[BMFCompoundDataStore alloc] initWithStores:@[ dataStore1, dataStore2, dataStore3 ]];
		
		id dataSource = [OCMockObject mockForProtocol:@protocol(BMFDataSourceProtocol)];
		[[[dataSource stub] andReturn:dataStore] dataStore];
		
		BMFEnumerateDataSourceAspect *aspect = [[BMFEnumerateDataSourceAspect alloc] init];
		[aspect setObject:dataSource];
		
		expect(aspect.mode).to.equal(BMFEnumerateDataSourceAspectModeForward);
		
		expect(aspect.indexPath.row).to.equal(0);
		expect(aspect.indexPath.section).to.equal(0);
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(1);
			expect([dataStore itemAt:result]).to.equal(@2);
			expect(result.section).to.equal(0);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(0);
			expect([dataStore itemAt:result]).to.equal(@3);
			expect(result.section).to.equal(1);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(0);
			expect([dataStore itemAt:result]).to.equal(@4);
			expect(result.section).to.equal(2);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(1);
			expect([dataStore itemAt:result]).to.equal(@5);
			expect(result.section).to.equal(2);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(0);
			expect([dataStore itemAt:result]).to.equal(@1);
			expect(result.section).to.equal(0);
		}];
	});
	
	it(@"should correctly enumerate bacward",^{
		BMFArrayDataStore *dataStore1 = [[BMFArrayDataStore alloc] init];
		dataStore1.items = @[ @1,@2 ];
		
		BMFArrayDataStore *dataStore2 = [[BMFArrayDataStore alloc] init];
		dataStore2.items = @[ @3 ];
		
		BMFArrayDataStore *dataStore3 = [[BMFArrayDataStore alloc] init];
		dataStore3.items = @[ @4, @5  ];
		
		
		BMFCompoundDataStore *dataStore = [[BMFCompoundDataStore alloc] initWithStores:@[ dataStore1, dataStore2, dataStore3 ]];
		
		id dataSource = [OCMockObject mockForProtocol:@protocol(BMFDataSourceProtocol)];
		[[[dataSource stub] andReturn:dataStore] dataStore];
		
		BMFEnumerateDataSourceAspect *aspect = [[BMFEnumerateDataSourceAspect alloc] init];
		aspect.mode = BMFEnumerateDataSourceAspectModeBackward;
		[aspect setObject:dataSource];
		
		expect(aspect.indexPath.row).to.equal(0);
		expect(aspect.indexPath.section).to.equal(0);
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(1);
			expect([dataStore itemAt:result]).to.equal(@5);
			expect(result.section).to.equal(2);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(0);
			expect([dataStore itemAt:result]).to.equal(@4);
			expect(result.section).to.equal(2);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(0);
			expect([dataStore itemAt:result]).to.equal(@3);
			expect(result.section).to.equal(1);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(1);
			expect([dataStore itemAt:result]).to.equal(@2);
			expect(result.section).to.equal(0);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(0);
			expect([dataStore itemAt:result]).to.equal(@1);
			expect(result.section).to.equal(0);
		}];
	});
});

describe(@"With condition", ^{
	it(@"shouldn't eumerate forward if the condition is false",^{
		BMFArrayDataStore *dataStore = [[BMFArrayDataStore alloc] init];
		dataStore.items = @[ @1,@2,@3,@4 ];
		
		id dataSource = [OCMockObject mockForProtocol:@protocol(BMFDataSourceProtocol)];
		[[[dataSource stub] andReturn:dataStore] dataStore];
		
		BMFEnumerateDataSourceAspect *aspect = [[BMFEnumerateDataSourceAspect alloc] init];
		aspect.condition = [BMFFalseCondition new];
		[aspect setObject:dataSource];
		
		expect(aspect.mode).to.equal(BMFEnumerateDataSourceAspectModeForward);
		
		expect(aspect.indexPath.row).to.equal(0);
		expect(aspect.indexPath.section).to.equal(0);
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(0);
			expect([dataStore itemAt:result]).to.equal(@1);
			expect(result.section).to.equal(0);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(0);
			expect([dataStore itemAt:result]).to.equal(@1);
			expect(result.section).to.equal(0);
		}];
	});
	
	it(@"shouldn't eumerate backward if the condition is false",^{
		BMFArrayDataStore *dataStore = [[BMFArrayDataStore alloc] init];
		dataStore.items = @[ @1,@2,@3,@4 ];
		
		id dataSource = [OCMockObject mockForProtocol:@protocol(BMFDataSourceProtocol)];
		[[[dataSource stub] andReturn:dataStore] dataStore];
		
		BMFEnumerateDataSourceAspect *aspect = [[BMFEnumerateDataSourceAspect alloc] init];
		aspect.mode = BMFEnumerateDataSourceAspectModeBackward;
		aspect.condition = [BMFFalseCondition new];
		[aspect setObject:dataSource];
		
		expect(aspect.indexPath.row).to.equal(0);
		expect(aspect.indexPath.section).to.equal(0);
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(0);
			expect([dataStore itemAt:result]).to.equal(@1);
			expect(result.section).to.equal(0);
		}];
		
		[aspect action:nil completion:^(NSIndexPath *result, NSError *error) {
			expect(error).to.beNil();
			expect(result.row).to.equal(0);
			expect([dataStore itemAt:result]).to.equal(@1);
			expect(result.section).to.equal(0);
		}];
	});
});

SpecEnd
