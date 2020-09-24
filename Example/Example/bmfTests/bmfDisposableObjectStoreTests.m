//
//  bmfDisposableObjectStoreTests.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 28/08/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import <BMF/BMFDisposableObjectDataStore.h>

SpecBegin(DisposableObjectStore)

describe(@"BMFDisposableObjectDataStore", ^{
	
	it(@"should generate correct random positive integers", ^{
		
		BMFDisposableObjectDataStore *dataStore = [[BMFDisposableObjectDataStore alloc] initWithCreationBlock:^id{
			return [[NSNumber alloc] initWithInt:3];
		}];

		NSNumber *originalNumber = dataStore.currentValue;
		
		expect(dataStore.currentValue).to.equal(originalNumber);
		expect(dataStore.currentValue).to.beIdenticalTo(originalNumber);
		[dataStore dispose];
		expect(dataStore.currentValue).to.equal(@3);
		
		dataStore.creationBlock = ^id() {
			return @5;
		};
		
		expect(dataStore.currentValue).to.equal(@5);
		
		[dataStore dispose];
		
		expect([dataStore valueForKey:@"value"]).to.beNil();
		expect(dataStore.currentValue).to.equal(@5);
	});
	
	
});


SpecEnd
