//
//  bmfDataStoreTests.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 08/04/14.
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

SharedExamplesBegin(SharedDataStores)

sharedExamplesFor(@"a single section data store", ^(NSDictionary *data) {
	
	id<BMFDataReadProtocol> dataStore = data[@"dataStore"];
	NSArray *items = data[@"items"];
	NSNumber *numSectionNumber = data[@"numSection"];
	NSInteger numSection = numSectionNumber.integerValue;

	it(@"should have the correct parameters",^{
		expect(dataStore).notTo.beNil();
		expect(items).notTo.beNil();
		expect(items.count).to.beGreaterThan(0);
		expect(numSectionNumber).notTo.beNil();
		expect(numSection).to.beGreaterThanOrEqualTo(0);
	});
	
	it(@"should have the correct number of rows and sections",^{
		expect([dataStore numberOfSections]).to.equal(1);
		expect([dataStore numberOfRowsInSection:0]).to.equal(items.count);
	});
	
	it(@"should return the correct index for each item",^{
		[items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			NSIndexPath *indexPath = [dataStore indexOfItem:obj];
			expect(indexPath).notTo.beNil();
			expect(indexPath.row).to.equal(idx);
			expect(indexPath.section).to.equal(0);
		}];
		
		expect([dataStore indexOfItem:nil]).to.beNil();
		expect([dataStore indexOfItem:@77]).to.beNil();
	});
	
	__block id value = nil;
	
	it(@"should should throw exception out of bounds and return the correct value inside bounds",^{
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:-1 inSection:0]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:0 inSection:-1]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:-1 inSection:-1]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		[items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			id value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:idx inSection:numSection]];
			expect(value).to.equal(obj);
		}];
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:items.count inSection:0]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:0 inSection:1]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:items.count inSection:1]]; }).to.raiseAny();
		expect(value).to.beNil();

	});
	
	it(@"should send notifications when data changes",^AsyncBlock{
		BMFArrayDataStore *dataStore = [BMFArrayDataStore new];
		NSArray *items = @[ @"First" ];
		dataStore.items = items;
				
		NSArray *newItems = @[ @"New", @"New2" ];
		
		[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataBatchChangeNotification object:dataStore] subscribeNext:^(id x) {
			
			expect(dataStore.numberOfSections).to.equal(1);
			expect([dataStore numberOfRowsInSection:0]).to.equal(2);
			
			expect([dataStore itemAt:0 row:0]).to.equal(newItems[0]);
			expect([dataStore itemAt:0 row:1]).to.equal(newItems[1]);
			
			done();
		}];
		
		dataStore.items = newItems;
	});
});


SharedExamplesEnd

SpecBegin(DataReads)

describe(@"BMFArrayDataStore", ^{
	BMFArrayDataStore *dataStore = [BMFArrayDataStore new];
	NSArray *items = @[ @"First", @"Second" ];
	dataStore.items = items;
	
	NSDictionary *data = @{ @"dataStore" : dataStore, @"items" : items, @"numSection" : @0 };
	itShouldBehaveLike(@"a single section data store",data);
});

describe(@"BMFFRCDataStore", ^{

	[MagicalRecord cleanUp];
	[MagicalRecord setDefaultModelFromClass:[Person class]];
	[MagicalRecord setupCoreDataStackWithInMemoryStore];
	
	Person *first = [Person MR_createEntity];
	first.name = @"First";
	
	Person *second = [Person MR_createEntity];
	second.name = @"Second";
	
	NSArray *items = @[ first, second ];
	
	NSFetchedResultsController *frc = [Person MR_fetchAllSortedBy:@"name" ascending:YES withPredicate:nil groupBy:nil delegate:nil];
	
	id<BMFDataReadProtocol> dataStore = [[BMFBase sharedInstance].factory dataStoreWithParameter:frc sender:self];
	
	NSDictionary *data = @{ @"dataStore" : dataStore, @"items" : items, @"numSection" : @0 };
	itShouldBehaveLike(@"a single section data store",data);
	
	[MagicalRecord cleanUp];
});

describe(@"BMFCompoundDataStore", ^{
	
	__block BMFCompoundDataStore *dataStore = nil;
	__block id observer = nil;
	
	afterEach(^{
		[[NSNotificationCenter defaultCenter] removeObserver:observer];
		observer = nil;
	});
	
	beforeEach(^{
		dataStore = nil;
	});
	
	it(@"should work correctly without stores", ^{
		expect(^{ dataStore = [[BMFCompoundDataStore alloc] initWithStores:nil]; }).to.raiseAny();
		expect(dataStore).to.beNil();
		expect(^{ dataStore = [[BMFCompoundDataStore alloc] initWithStores:@[ ]]; }).to.raiseAny();
		expect(dataStore).to.beNil();
	});
	
	it(@"should work correctly", ^{
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		NSArray *items = @[ @"First" ];
		firstStore.items = items;
		
		BMFArrayDataStore *secondStore = [BMFArrayDataStore new];
		NSArray *secondItems = @[ @"Second" ];
		secondStore.items = secondItems;
		
		dataStore = [[BMFCompoundDataStore alloc] initWithStores:@[ firstStore, secondStore ]];
		
		__block id value = nil;
		
		expect(dataStore.numberOfSections).to.equal(2);
		expect([dataStore numberOfRowsInSection:0]).to.equal(1);
		expect([dataStore numberOfRowsInSection:1]).to.equal(1);
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:-1 inSection:0]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:0 inSection:-1]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:-1 inSection:-1]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect([dataStore itemAt:0 row:0]).to.equal(items.firstObject);
		expect([dataStore itemAt:1 row:0]).to.equal(secondItems.firstObject);
		
		expect([dataStore indexOfItem:items.firstObject].row).to.equal(0);
		expect([dataStore indexOfItem:items.firstObject].section).to.equal(0);

		expect([dataStore indexOfItem:secondItems.firstObject].row).to.equal(0);
		expect([dataStore indexOfItem:secondItems.firstObject].section).to.equal(1);

		expect([dataStore indexOfItem:nil]).to.beNil();
		expect([dataStore indexOfItem:@77]).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:items.count inSection:0]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:0 inSection:30]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:items.count inSection:30]]; }).to.raiseAny();
		expect(value).to.beNil();
	});
	
	it(@"should work correctly with some empty stores as input", ^{
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		NSArray *items = @[ @"First" ];
		firstStore.items = items;
		
		BMFArrayDataStore *secondStore = [BMFArrayDataStore new];
		
		dataStore = [[BMFCompoundDataStore alloc] initWithStores:@[ firstStore, secondStore ]];
		
		__block id value = nil;
		
		expect(dataStore.numberOfSections).to.equal(2);
		expect([dataStore numberOfRowsInSection:0]).to.equal(1);
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:-1 inSection:0]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:0 inSection:-1]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:-1 inSection:-1]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect([dataStore itemAt:0 row:0]).to.equal(items.firstObject);
				
		expect(^{ value = [dataStore itemAt:1 row:0]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:items.count inSection:0]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:0 inSection:30]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:items.count inSection:30]]; }).to.raiseAny();
		expect(value).to.beNil();

	});
	
	it(@"should pass changes made to the original stores",^AsyncBlock{
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		NSArray *items = @[ @"First" ];
		firstStore.items = items;
		
		BMFArrayDataStore *secondStore = [BMFArrayDataStore new];
		secondStore.items = @[ @"Second" ];
		
		dataStore = [[BMFCompoundDataStore alloc] initWithStores:@[ firstStore, secondStore ]];
		
		NSArray *newItems = @[ @"New", @"New2" ];

		observer = [[NSNotificationCenter defaultCenter] addObserverForName:BMFDataBatchChangeNotification object:dataStore queue:nil usingBlock:^(NSNotification *note) {
			NSLog(@"compound data store: %@",dataStore);

			expect(dataStore.numberOfSections).to.equal(2);
			expect([dataStore numberOfRowsInSection:0]).to.equal(2);

			expect([dataStore itemAt:0 row:0]).to.equal(newItems[0]);
			expect([dataStore itemAt:0 row:1]).to.equal(newItems[1]);
			
			done();
		}];
		
		expect(^{ firstStore.items = newItems; }).to.notify(BMFDataBatchChangeNotification);
	});
});

describe(@"BMFRowsAsSectionsDataStore", ^{
	
	__block id observer = nil;
	__block BMFRowsAsSectionsDataStore *dataStore = nil;
	
	afterEach(^{
		[[NSNotificationCenter defaultCenter] removeObserver:observer];
		observer = nil;
	});
	
	beforeEach(^{
		dataStore = nil;
	});
	
	it(@"should work correctly without stores", ^{
		
		expect(^{ dataStore = [[BMFRowsAsSectionsDataStore alloc] initWithStores:@[ ]]; }).to.raiseAny();
		
		expect(dataStore).to.beNil();
		
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		dataStore = [[BMFRowsAsSectionsDataStore alloc] initWithStores:@[ firstStore ]];
		
		expect(dataStore).notTo.beNil();
		expect(dataStore.numberOfSections).to.equal(0);

		expect(^{ [dataStore setDataStores:nil]; }).to.raiseAny();
		expect(^{ [dataStore setDataStores:@[]]; }).to.raiseAny();
	});
	
	it(@"should work correctly with 1 store", ^{
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		NSArray *items = @[ @"First",@"Second",@"Third" ];
		firstStore.items = items;
		
		dataStore = [[BMFRowsAsSectionsDataStore alloc] initWithStores:@[ firstStore ]];
		
		__block id value = nil;
		
		expect(dataStore.numberOfSections).to.equal(3);
		expect([dataStore numberOfRowsInSection:0]).to.equal(1);
		expect([dataStore numberOfRowsInSection:1]).to.equal(1);
		expect([dataStore numberOfRowsInSection:2]).to.equal(1);
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:-1 inSection:0]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:0 inSection:-1]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:-1 inSection:-1]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect([dataStore itemAt:0 row:0]).to.equal(items.firstObject);
		expect([dataStore itemAt:1 row:0]).to.equal(items[1]);
		expect([dataStore itemAt:2 row:0]).to.equal(items[2]);
		
		expect([dataStore indexOfItem:items.firstObject].row).to.equal(0);
		expect([dataStore indexOfItem:items.firstObject].section).to.equal(0);
		
		expect([dataStore indexOfItem:items[1]].row).to.equal(0);
		expect([dataStore indexOfItem:items[1]].section).to.equal(1);

		expect([dataStore indexOfItem:items[2]].row).to.equal(0);
		expect([dataStore indexOfItem:items[2]].section).to.equal(2);
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:items.count inSection:0]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:0 inSection:30]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:items.count inSection:30]]; }).to.raiseAny();
		expect(value).to.beNil();
	});
	
	it(@"should work correctly with multiple stores", ^{
		
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		NSArray *items = @[ @"First",@"Second" ];
		firstStore.items = items;

		BMFArrayDataStore *secondStore = [BMFArrayDataStore new];
		NSArray *secondItems = @[ @"Third" ];
		secondStore.items = secondItems;

		dataStore = [[BMFRowsAsSectionsDataStore alloc] initWithStores:@[ firstStore, secondStore ]];
		
		__block id value = nil;
		
		expect(dataStore.numberOfSections).to.equal(3);
		expect([dataStore numberOfRowsInSection:0]).to.equal(1);
		expect([dataStore numberOfRowsInSection:1]).to.equal(1);
		expect([dataStore numberOfRowsInSection:2]).to.equal(1);
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:-1 inSection:0]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:0 inSection:-1]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:-1 inSection:-1]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect([dataStore itemAt:0 row:0]).to.equal(items.firstObject);
		expect([dataStore itemAt:1 row:0]).to.equal(items[1]);
		expect([dataStore itemAt:2 row:0]).to.equal(secondItems.firstObject);
		
		expect([dataStore indexOfItem:items.firstObject].row).to.equal(0);
		expect([dataStore indexOfItem:items.firstObject].section).to.equal(0);
		
		expect([dataStore indexOfItem:items[1]].row).to.equal(0);
		expect([dataStore indexOfItem:items[1]].section).to.equal(1);
		
		expect([dataStore indexOfItem:secondItems.firstObject].row).to.equal(0);
		expect([dataStore indexOfItem:secondItems.firstObject].section).to.equal(2);
		
		expect([dataStore indexOfItem:nil]).to.beNil();
		expect([dataStore indexOfItem:@77]).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:items.count inSection:0]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:0 inSection:30]]; }).to.raiseAny();
		expect(value).to.beNil();
		
		expect(^{ value = [dataStore itemAt:[NSIndexPath BMF_indexPathForRow:items.count inSection:30]]; }).to.raiseAny();
		expect(value).to.beNil();
	});
	
	it(@"should pass changes made to the original stores",^AsyncBlock{
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		NSArray *items = @[ @"First" ];
		firstStore.items = items;
		
		BMFArrayDataStore *secondStore = [BMFArrayDataStore new];
		secondStore.items = @[ @"Second" ];
		
		dataStore = [[BMFRowsAsSectionsDataStore alloc] initWithStores:@[ firstStore, secondStore ]];
		
		NSArray *newItems = @[ @"New", @"New2" ];
		
		
		NSLog(@"Observing: %@",dataStore);
		observer = [[NSNotificationCenter defaultCenter] addObserverForName:BMFDataBatchChangeNotification object:dataStore queue:nil usingBlock:^(NSNotification *note) {
			NSLog(@"rowsassectinos sections data store: %@",dataStore);
			
			expect(dataStore.numberOfSections).to.equal(3);
			
			expect([dataStore itemAt:0 row:0]).to.equal(newItems[0]);
			expect([dataStore itemAt:1 row:0]).to.equal(newItems[1]);
			expect([dataStore itemAt:2 row:0]).to.equal([secondStore allItems][0]);
			
			done();
		}];
		
		expect(^{ firstStore.items = newItems; }).to.notify(BMFDataBatchChangeNotification);
	});
});

describe(@"BMFFlattenSectionsDataStore", ^{
	__block id observer = nil;
	__block BMFFlattenSectionsDataStore *dataStore = nil;
		
	beforeEach(^{
		dataStore = nil;
	});
	
	afterEach(^{
		[[NSNotificationCenter defaultCenter] removeObserver:observer];
		observer = nil;
	});

	
	it(@"should work correctly without stores", ^{
		
		__block BMFFlattenSectionsDataStore *dataStore = nil;
		
		expect(^{ dataStore = [[BMFFlattenSectionsDataStore alloc] initWithStores:@[ ]]; }).to.raiseAny();
		
		expect(dataStore).to.beNil();
		
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		dataStore = [[BMFFlattenSectionsDataStore alloc] initWithStores:@[ firstStore ]];
		
		expect(dataStore).notTo.beNil();
		expect(dataStore.numberOfSections).to.equal(0);
		
		expect(^{ [dataStore setDataStores:nil]; }).to.raiseAny();
		expect(^{ [dataStore setDataStores:@[]]; }).to.raiseAny();
	});
	
	it(@"should work correctly with 1 store", ^{
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		NSArray *items = @[ @"First",@"Second",@"Third" ];
		firstStore.items = items;
		
		dataStore = [[BMFFlattenSectionsDataStore alloc] initWithStores:@[ firstStore ]];
		
		NSDictionary *data = @{ @"dataStore" : dataStore, @"items" : items, @"numSection" : @0 };
		itShouldBehaveLike(@"a single section data store",data);
	});
	
	it(@"should work correctly with multiple stores", ^{
		
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		NSArray *items = @[ @"First",@"Second" ];
		firstStore.items = items;
		
		BMFArrayDataStore *secondStore = [BMFArrayDataStore new];
		NSArray *secondItems = @[ @"Third" ];
		secondStore.items = secondItems;
		
		dataStore = [[BMFFlattenSectionsDataStore alloc] initWithStores:@[ firstStore, secondStore ]];
		
		NSDictionary *data = @{ @"dataStore" : dataStore, @"items" : [items arrayByAddingObjectsFromArray:secondItems], @"numSection" : @0 };
		itShouldBehaveLike(@"a single section data store",data);
	});
	
	it(@"should work correctly with multiple stores, some empty", ^{
		
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		NSArray *items = @[ @"First",@"Second" ];
		firstStore.items = items;

		BMFArrayDataStore *secondStore = [BMFArrayDataStore new];
		NSArray *secondItems = @[  ];
		secondStore.items = secondItems;
		
		BMFArrayDataStore *thirdStore = [BMFArrayDataStore new];
		NSArray *thirdItems = @[ @"Third" ];
		thirdStore.items = thirdItems;
		
		dataStore = [[BMFFlattenSectionsDataStore alloc] initWithStores:@[ firstStore, secondStore, thirdStore ]];
		
		NSArray *allItems = [items arrayByAddingObjectsFromArray:secondItems];
		allItems = [allItems arrayByAddingObjectsFromArray:thirdItems];
		NSDictionary *data = @{ @"dataStore" : dataStore, @"items" : allItems, @"numSection" : @0 };
		itShouldBehaveLike(@"a single section data store",data);
	});
	
	it(@"should pass changes made to the original stores",^AsyncBlock{
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		NSArray *items = @[ @"First" ];
		firstStore.items = items;
		
		BMFArrayDataStore *secondStore = [BMFArrayDataStore new];
		secondStore.items = @[ @"Second" ];
		
		dataStore = [[BMFFlattenSectionsDataStore alloc] initWithStores:@[ firstStore, secondStore ]];
		
		NSArray *newItems = @[ @"New", @"New2" ];
		
		observer = [[NSNotificationCenter defaultCenter] addObserverForName:BMFDataBatchChangeNotification object:dataStore queue:nil usingBlock:^(NSNotification *note) {
			
			NSLog(@"flatten sections data store: %@",dataStore);
			
			expect(dataStore.numberOfSections).to.equal(1);
			
			expect([dataStore itemAt:0 row:0]).to.equal(newItems[0]);
			expect([dataStore itemAt:0 row:1]).to.equal(newItems[1]);
			expect([dataStore itemAt:0 row:2]).to.equal([secondStore allItems][0]);
			
			done();
		}];
		
		expect(^{ firstStore.items = newItems; }).to.notify(BMFDataBatchChangeNotification);
	});
});

describe(@"BMFGroupsDataStore", ^{
	__block id observer = nil;
	__block BMFGroupsDataStore *dataStore = nil;
	
	beforeEach(^{
		dataStore = nil;
	});
	
	afterEach(^{
		[[NSNotificationCenter defaultCenter] removeObserver:observer];
		observer = nil;
	});
	
	
	it(@"shouldn't allow to have no stores", ^{
		
		__block BMFGroupsDataStore *dataStore = nil;
		
		expect(^{ dataStore = [[BMFGroupsDataStore alloc] initWithDataStore:nil childrenBlock:^NSArray *(id group) {
			return nil;
		}]; }).to.raiseAny();

		expect(dataStore).to.beNil();
		
		expect(^{ dataStore = [[BMFGroupsDataStore alloc] initWithDataStore:[BMFArrayDataStore new] childrenBlock:nil]; }).to.raiseAny();
		
		expect(dataStore).to.beNil();
		
		expect(^{ dataStore = [[BMFGroupsDataStore alloc] initWithDataStore:nil childrenBlock:nil]; }).to.raiseAny();
		
		expect(dataStore).to.beNil();
		
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		dataStore = [[BMFGroupsDataStore alloc] initWithDataStore:firstStore childrenBlock:^NSArray *(id group) {
			return nil;
		}];
		
		expect(dataStore).notTo.beNil();
		expect(dataStore.numberOfSections).to.equal(1);
		
		expect(^{ [dataStore setDataStore:nil]; }).to.raiseAny();
	});
	
	it(@"should work correctly with 1 section", ^{
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		dataStore = [[BMFGroupsDataStore alloc] initWithDataStore:firstStore childrenBlock:^NSArray *(BMFGroup *group) {
			return group.children;
		}];
		
		expect(dataStore).notTo.beNil();
		expect(dataStore.numberOfSections).to.equal(1);

		BMFGroup *group1 = [BMFGroup new];
		NSString *child1 = @"child1";
		NSString *child2 = @"child2";
		group1.children = [@[ child1, child2 ] mutableCopy];
		
		firstStore.items = @[ group1 ];

		expect(dataStore.numberOfSections).to.equal(1);
		expect([dataStore numberOfRowsInSection:0]).to.equal(3);
		expect([dataStore itemAt:0 row:0]).to.equal(group1);
		expect([dataStore itemAt:0 row:1]).to.equal(child1);
		expect([dataStore itemAt:0 row:2]).to.equal(child2);
		expect(^{ [dataStore itemAt:0 row:3]; }).to.raiseAny();
		expect(^{ [dataStore itemAt:1 row:0]; }).to.raiseAny();
	});
	
	it(@"should work correctly with multiple groups", ^{
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		dataStore = [[BMFGroupsDataStore alloc] initWithDataStore:firstStore childrenBlock:^NSArray *(BMFGroup *group) {
			return group.children;
		}];
		
		expect(dataStore).notTo.beNil();
		expect(dataStore.numberOfSections).to.equal(1);
		
		BMFGroup *group1 = [BMFGroup new];
		NSString *child1 = @"child1";
		NSString *child2 = @"child2";
		group1.children = [@[ child1, child2 ] mutableCopy];
		BMFGroup *group2 = [BMFGroup new];
		NSString *child3 = @"child3";
		group2.children = [@[ child3 ] mutableCopy];
		firstStore.items = @[ group1, group2 ];
		
		expect(dataStore.numberOfSections).to.equal(1);
		expect([dataStore numberOfRowsInSection:0]).to.equal(5);
		expect(^{ [dataStore numberOfRowsInSection:1]; }).to.raiseAny();
		
		expect([dataStore itemAt:0 row:0]).to.equal(group1);
		expect([dataStore itemAt:0 row:1]).to.equal(child1);
		expect([dataStore itemAt:0 row:2]).to.equal(child2);
		expect([dataStore itemAt:0 row:3]).to.equal(group2);
		expect([dataStore itemAt:0 row:4]).to.equal(child3);
		expect(^{ [dataStore itemAt:0 row:5]; }).to.raiseAny();
		expect(^{ [dataStore itemAt:1 row:0]; }).to.raiseAny();
	});
	
	it(@"should work correctly if some groups have no items", ^{
		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
		dataStore = [[BMFGroupsDataStore alloc] initWithDataStore:firstStore childrenBlock:^NSArray *(BMFGroup *group) {
			return group.children;
		}];
		
		expect(dataStore).notTo.beNil();
		expect(dataStore.numberOfSections).to.equal(1);
		
		BMFGroup *group1 = [BMFGroup new];
		BMFGroup *group2 = [BMFGroup new];
		NSString *child1 = @"child1";
		NSString *child2 = @"child2";
		NSString *child3 = @"child3";
		group2.children = [@[ child1,child2,child3 ] mutableCopy];
		firstStore.items = [@[ group1, group2 ] mutableCopy];
		
		expect(dataStore.numberOfSections).to.equal(1);
		expect([dataStore numberOfRowsInSection:0]).to.equal(5);
		expect([dataStore itemAt:0 row:0]).to.equal(group1);
		expect([dataStore itemAt:0 row:1]).to.equal(group2);
		expect([dataStore itemAt:0 row:2]).to.equal(child1);
		expect([dataStore itemAt:0 row:3]).to.equal(child2);
		expect([dataStore itemAt:0 row:4]).to.equal(child3);
		expect(^{ [dataStore itemAt:0 row:5]; }).to.raiseAny();
		expect(^{ [dataStore itemAt:1 row:0]; }).to.raiseAny();
	});
	
	it(@"should work correctly with multiple sections", ^{
		#warning TODO
	});
		
	it(@"should pass changes made to the original stores",^AsyncBlock{
		done();
		
//		BMFArrayDataStore *firstStore = [BMFArrayDataStore new];
//		NSArray *items = @[ @"First" ];
//		firstStore.items = items;
//		
//		BMFArrayDataStore *secondStore = [BMFArrayDataStore new];
//		secondStore.items = @[ @"Second" ];
//		
//		dataStore = [[BMFFlattenSectionsDataStore alloc] initWithStores:@[ firstStore, secondStore ]];
//		
//		NSArray *newItems = @[ @"New", @"New2" ];
//		
//		observer = [[NSNotificationCenter defaultCenter] addObserverForName:BMFDataBatchChangeNotification object:dataStore queue:nil usingBlock:^(NSNotification *note) {
//			
//			NSLog(@"flatten sections data store: %@",dataStore);
//			
//			expect(dataStore.numberOfSections).to.equal(1);
//			
//			expect([dataStore itemAt:0 row:0]).to.equal(newItems[0]);
//			expect([dataStore itemAt:0 row:1]).to.equal(newItems[1]);
//			expect([dataStore itemAt:0 row:2]).to.equal(secondStore.items[0]);
//			
//			done();
//		}];
//		
//		expect(^{ firstStore.items = newItems; }).to.notify(BMFDataBatchChangeNotification);
	});
});

SpecEnd

