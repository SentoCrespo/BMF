//
//  bmfUtilsTests.m
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

#import <BMF/BMFUtils.h>
#import <BMF/BMFArrayDataStore.h>

SpecBegin(Utils)

describe(@"BMFUtils random", ^{
	
	it(@"should generate correct random positive integers", ^{
		
		__block NSInteger random = [BMFUtils randomInteger:20 max:200];
		expect(random).to.beGreaterThanOrEqualTo(20);
		expect(random).to.beLessThanOrEqualTo(200);

		random = [BMFUtils randomInteger:0 max:2];
		expect(random).to.beGreaterThanOrEqualTo(0);
		expect(random).to.beLessThanOrEqualTo(2);
		
		expect(^{ [BMFUtils randomInteger:1 max:1]; }).to.raiseAny();
		
		expect(^{ random = [BMFUtils randomInteger:5 max:0]; }).to.raiseAny();
	});
	
	it(@"should generate correct random negative integers", ^{
		
		__block NSInteger random = [BMFUtils randomInteger:-200 max:-20];
		expect(random).to.beGreaterThanOrEqualTo(-200);
		expect(random).to.beLessThanOrEqualTo(-20);
		
		random = [BMFUtils randomInteger:-2 max:0];
		expect(random).to.beGreaterThanOrEqualTo(-2);
		expect(random).to.beLessThanOrEqualTo(0);
		
		expect(^{ [BMFUtils randomInteger:-1 max:-1]; }).to.raiseAny();
		
		expect(^{ random = [BMFUtils randomInteger:0 max:-5]; }).to.raiseAny();
	});
	
	it(@"should generate correct random positive doubles", ^{
		
		__block double random = [BMFUtils randomDouble:20.1 max:200.5];
		expect(random).to.beGreaterThanOrEqualTo(20.1);
		expect(random).to.beLessThanOrEqualTo(200.5);
		
		random = [BMFUtils randomDouble:0.5 max:1.9];
		expect(random).to.beGreaterThanOrEqualTo(0.5);
		expect(random).to.beLessThanOrEqualTo(1.9);
		
		expect(^{ [BMFUtils randomDouble:1.1 max:1.1]; }).to.raiseAny();
		
		expect(^{ random = [BMFUtils randomDouble:5.0 max:0.1]; }).to.raiseAny();
	});
	
	it(@"should generate correct random negative doubles", ^{
		
		__block double random = [BMFUtils randomDouble:-200 max:-20];
		expect(random).to.beGreaterThanOrEqualTo(-200);
		expect(random).to.beLessThanOrEqualTo(-20);
		
		random = [BMFUtils randomDouble:-2 max:0];
		expect(random).to.beGreaterThanOrEqualTo(-2);
		expect(random).to.beLessThanOrEqualTo(0);
		
		expect(^{ [BMFUtils randomDouble:-1 max:-1]; }).to.raiseAny();
		
		expect(^{ random = [BMFUtils randomDouble:0 max:-5]; }).to.raiseAny();
	});
});

describe(@"BMFUtils data store", ^{
	
	it(@"should work for data stores without rows", ^{
		BMFArrayDataStore *ds = [[BMFArrayDataStore alloc] init];
		expect(^{[BMFUtils predecessorOf:[NSIndexPath BMF_indexPathForRow:0 inSection:0] inDataSource:ds wrap:NO];}).to.raiseAny();
		expect(^{[BMFUtils predecessorOf:[NSIndexPath BMF_indexPathForRow:0 inSection:0] inDataSource:ds wrap:YES];}).to.raiseAny();

		expect(^{[BMFUtils sucessorOf:[NSIndexPath BMF_indexPathForRow:0 inSection:0] inDataSource:ds wrap:NO];}).to.raiseAny();
		expect(^{[BMFUtils sucessorOf:[NSIndexPath BMF_indexPathForRow:0 inSection:0] inDataSource:ds wrap:YES];}).to.raiseAny();

		expect(^{[BMFUtils predecessorOf:[NSIndexPath BMF_indexPathForRow:1 inSection:0] inDataSource:ds wrap:NO];}).to.raiseAny();
		expect(^{[BMFUtils predecessorOf:[NSIndexPath BMF_indexPathForRow:1 inSection:0] inDataSource:ds wrap:YES];}).to.raiseAny();
		
		expect(^{[BMFUtils sucessorOf:[NSIndexPath BMF_indexPathForRow:1 inSection:0] inDataSource:ds wrap:NO];}).to.raiseAny();
		expect(^{[BMFUtils sucessorOf:[NSIndexPath BMF_indexPathForRow:1 inSection:0] inDataSource:ds wrap:YES];}).to.raiseAny();

		expect(^{[BMFUtils predecessorOf:[NSIndexPath BMF_indexPathForRow:0 inSection:1] inDataSource:ds wrap:NO];}).to.raiseAny();
		expect(^{[BMFUtils predecessorOf:[NSIndexPath BMF_indexPathForRow:0 inSection:1] inDataSource:ds wrap:YES];}).to.raiseAny();
		
		expect(^{[BMFUtils sucessorOf:[NSIndexPath BMF_indexPathForRow:0 inSection:1] inDataSource:ds wrap:NO];}).to.raiseAny();
		expect(^{[BMFUtils sucessorOf:[NSIndexPath BMF_indexPathForRow:0 inSection:1] inDataSource:ds wrap:YES];}).to.raiseAny();
	});
	
	it(@"should work for data stores with 1 section", ^{
		BMFArrayDataStore *ds = [[BMFArrayDataStore alloc] init];
		ds.items = @[ @"first", @"second", @"third" ];

		expect([BMFUtils predecessorOf:[NSIndexPath BMF_indexPathForRow:0 inSection:0] inDataSource:ds wrap:NO]).to.equal([NSIndexPath BMF_indexPathForRow:0 inSection:0]);
		expect([BMFUtils predecessorOf:[NSIndexPath BMF_indexPathForRow:0 inSection:0] inDataSource:ds wrap:YES]).to.equal([NSIndexPath BMF_indexPathForRow:2 inSection:0]);
		expect([BMFUtils predecessorOf:[NSIndexPath BMF_indexPathForRow:1 inSection:0] inDataSource:ds wrap:NO]).to.equal([NSIndexPath BMF_indexPathForRow:0 inSection:0]);
		expect([BMFUtils predecessorOf:[NSIndexPath BMF_indexPathForRow:1 inSection:0] inDataSource:ds wrap:YES]).to.equal([NSIndexPath BMF_indexPathForRow:0 inSection:0]);
		expect([BMFUtils predecessorOf:[NSIndexPath BMF_indexPathForRow:2 inSection:0] inDataSource:ds wrap:NO]).to.equal([NSIndexPath BMF_indexPathForRow:1 inSection:0]);
		expect([BMFUtils predecessorOf:[NSIndexPath BMF_indexPathForRow:2 inSection:0] inDataSource:ds wrap:YES]).to.equal([NSIndexPath BMF_indexPathForRow:1 inSection:0]);
		
		expect([BMFUtils sucessorOf:[NSIndexPath BMF_indexPathForRow:0 inSection:0] inDataSource:ds wrap:NO]).to.equal([NSIndexPath BMF_indexPathForRow:1 inSection:0]);
		expect([BMFUtils sucessorOf:[NSIndexPath BMF_indexPathForRow:0 inSection:0] inDataSource:ds wrap:YES]).to.equal([NSIndexPath BMF_indexPathForRow:1 inSection:0]);
		expect([BMFUtils sucessorOf:[NSIndexPath BMF_indexPathForRow:1 inSection:0] inDataSource:ds wrap:NO]).to.equal([NSIndexPath BMF_indexPathForRow:2 inSection:0]);
		expect([BMFUtils sucessorOf:[NSIndexPath BMF_indexPathForRow:1 inSection:0] inDataSource:ds wrap:YES]).to.equal([NSIndexPath BMF_indexPathForRow:2 inSection:0]);
		expect([BMFUtils sucessorOf:[NSIndexPath BMF_indexPathForRow:2 inSection:0] inDataSource:ds wrap:NO]).to.equal([NSIndexPath BMF_indexPathForRow:2 inSection:0]);
		expect([BMFUtils sucessorOf:[NSIndexPath BMF_indexPathForRow:2 inSection:0] inDataSource:ds wrap:YES]).to.equal([NSIndexPath BMF_indexPathForRow:0 inSection:0]);
	});

	it(@"should work for data stores with multiple sections", ^{
		
	});

});

SpecEnd