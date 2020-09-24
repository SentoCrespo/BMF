//
//  bmfDataStoreProtocolTests.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/08/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "BMF.h"

#import "BMFArrayDataStore.h"
#import "BMFCompoundDataStore.h"
#import "BMFRowsAsSectionsDataStore.h"
#import "BMFFlattenSectionsDataStore.h"
#import "BMFGroupsDataStore.h"

#import "BMFGroup.h"

#import "Person.h"

#import <MagicalRecord/MagicalRecord.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

SpecBegin(DataStores)

	describe(@"BMFArrayDataStore", ^{
		
		it(@"Should allow to remove and add items", ^{
			BMFArrayDataStore *dataStore = [BMFArrayDataStore new];
			NSArray *items = @[ @"First", @"Second" ];
			dataStore.items = items;
			
			expect([dataStore removeItem:@"First"]).to.beTruthy();
			expect([dataStore allItems].count).to.equal(1);
			
			expect([dataStore addItem:@"First"]).to.beTruthy();
			expect([dataStore itemAt:0 row:1]).to.equal(@"First");
		});
		
	});


	describe(@"BMFCompoundDataStore", ^{
		it(@"Should allow to remove and add items", ^{
			BMFArrayDataStore *dataStore = [BMFArrayDataStore new];
			NSArray *items = @[ @"First", @"Second" ];
			dataStore.items = items;
			
			BMFArrayDataStore *dataStore2 = [BMFArrayDataStore new];
			NSArray *items2 = @[ @"1", @"3" ];
			dataStore2.items = items2;
			
			BMFCompoundDataStore *compoundDataStore = [[BMFCompoundDataStore alloc] initWithStores:@[ dataStore, dataStore2 ]];
			expect([compoundDataStore numberOfSections]).to.equal(2);
			expect([compoundDataStore numberOfRowsInSection:0]).to.equal(2);
			expect([compoundDataStore numberOfRowsInSection:1]).to.equal(2);
			
			[compoundDataStore startUpdating];
			expect([compoundDataStore insertItem:@"2" atIndexPath:[NSIndexPath BMF_indexPathForRow:1 inSection:1]]).to.beTruthy();
			[compoundDataStore endUpdating];
			
			expect([compoundDataStore numberOfRowsInSection:1]).to.equal(3);
			expect([compoundDataStore itemAt:1 row:0]).to.equal(@"1");
			expect([compoundDataStore itemAt:1 row:1]).to.equal(@"2");
			expect([compoundDataStore itemAt:1 row:2]).to.equal(@"3");
		});
	});

SpecEnd