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

#import "BMFObjectDataStore.h"
#import "BMFManagedObjectStore.h"

#import "Person.h"

#import <MagicalRecord/MagicalRecord.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

SpecBegin(ObjectDataStores)

describe(@"BMFObjectDataStore", ^{
	
	it(@"should store correctly one object",^{
		BMFObjectDataStore *dataStore = [BMFObjectDataStore new];
		
		__block BOOL called = NO;
		dataStore.applyValueBlock = ^(id sender) {
			called = YES;
		};

		expect(called).to.beTruthy();
		
		NSNumber *number = @23;
		
		dataStore.currentValue = number;
		
		expect(dataStore.currentValue).to.equal(number);
		expect(dataStore.currentValue).to.equal(@23);

		expect(called).to.beTruthy();
		
		called = NO;
		
		dataStore.currentValue = @70;
		expect(dataStore.currentValue).to.equal(@70);
		expect(called).to.beTruthy();
		
		called = NO;
		
		dataStore.currentValue = nil;
		expect(dataStore.currentValue).to.beNil();
		expect(called).to.beTruthy();
			
	});
});

describe(@"BMFManagedObjectDataStore", ^{
	
	it(@"should store correctly a managed object and respond to changes",^{
		[MagicalRecord cleanUp];
		[MagicalRecord setDefaultModelFromClass:[Person class]];
		[MagicalRecord setupCoreDataStackWithInMemoryStore];
		
		Person *first = [Person MR_createEntity];
		first.name = @"First";
		[first.managedObjectContext MR_saveToPersistentStoreAndWait];

		BMFManagedObjectStore *dataStore = [BMFManagedObjectStore new];
		dataStore.currentValue = first;

		__block BOOL called = NO;
		dataStore.applyValueBlock = ^(id sender) {
			called = YES;
		};
		
		first.name = @"blah";
		[first.managedObjectContext MR_saveToPersistentStoreAndWait];

		expect(called).to.beTruthy();
		
		[first MR_deleteEntity];
		[first.managedObjectContext MR_saveToPersistentStoreAndWait];
		expect(dataStore.currentValue).to.beNil();
		
		[MagicalRecord cleanUp];
	});
});

SpecEnd

