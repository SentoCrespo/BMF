//
//  BMFDataStoreSelectionTests.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/07/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <UIKit/UIKit.h>

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import <BMF/BMFDataStoreSelection.h>

SpecBegin(BMFDataStoreSelection)

describe(@"Single Selection", ^{
	
	__block BMFDataStoreSelection *selection = nil;
	
	beforeEach(^{
		selection = [BMFDataStoreSelection new];
		selection.mode = BMFDataStoreSelectionModeSingle;
	});
	
	it(@"should never have more than one element selected", ^{
		expect(selection.selection.count).to.equal(0);
		
		[selection select:[NSIndexPath indexPathForRow:0 inSection:0]];
		
		expect(selection.selection.count).to.equal(1);
		
		NSIndexPath *indexPath = selection.selection.firstObject;
		expect(indexPath.section).to.equal(0);
		expect(indexPath.row).to.equal(0);
		
		[selection select:[NSIndexPath indexPathForRow:1 inSection:0]];

		expect(selection.selection.count).to.equal(1);
		
		indexPath = selection.selection.firstObject;
		expect(indexPath.section).to.equal(0);
		expect(indexPath.row).to.equal(1);
	});
	
	it(@"should deselect elements correctly", ^{
		expect(selection.selection.count).to.equal(0);

		[selection select:[NSIndexPath indexPathForRow:0 inSection:0]];
		
		expect(selection.selection.count).to.equal(1);
		
		NSIndexPath *indexPath = selection.selection.firstObject;
		expect(indexPath.section).to.equal(0);
		expect(indexPath.row).to.equal(0);

		[selection deselect:[NSIndexPath indexPathForRow:0 inSection:0]];
		
		expect(selection.selection.count).to.equal(0);
	});
});


describe(@"Single Selection per Section", ^{
	__block BMFDataStoreSelection *selection = nil;
	
	beforeEach(^{
		selection = [BMFDataStoreSelection new];
		selection.mode = BMFDataStoreSelectionModeSinglePerSection;
	});
	
	it(@"should never have more than one element selected per section", ^{
		expect(selection.selection.count).to.equal(0);
		
		[selection select:[NSIndexPath indexPathForRow:0 inSection:0]];
		
		expect(selection.selection.count).to.equal(1);

		NSIndexPath *indexPath = selection.selection.firstObject;
		expect(indexPath.section).to.equal(0);
		expect(indexPath.row).to.equal(0);
		
		[selection select:[NSIndexPath indexPathForRow:1 inSection:0]];
		
		expect(selection.selection.count).to.equal(1);
		
		indexPath = selection.selection.firstObject;
		expect(indexPath.section).to.equal(0);
		expect(indexPath.row).to.equal(1);

		[selection select:[NSIndexPath indexPathForRow:1 inSection:1]];
		
		expect(selection.selection.count).to.equal(2);
		
		indexPath = selection.selection[1];
		expect(indexPath.section).to.equal(1);
		expect(indexPath.row).to.equal(1);

		[selection select:[NSIndexPath indexPathForRow:3 inSection:1]];
		
		expect(selection.selection.count).to.equal(2);
		
		indexPath = selection.selection[1];
		expect(indexPath.section).to.equal(1);
		expect(indexPath.row).to.equal(3);
	});

	it(@"should deselect elements correctly", ^{
		expect(selection.selection.count).to.equal(0);
		
		[selection select:[NSIndexPath indexPathForRow:0 inSection:0]];
		
		expect(selection.selection.count).to.equal(1);
		
		NSIndexPath *indexPath = selection.selection.firstObject;
		expect(indexPath.section).to.equal(0);
		expect(indexPath.row).to.equal(0);

		[selection select:[NSIndexPath indexPathForRow:1 inSection:1]];
		
		expect(selection.selection.count).to.equal(2);
		
		indexPath = selection.selection[1];
		expect(indexPath.section).to.equal(1);
		expect(indexPath.row).to.equal(1);

		[selection deselect:[NSIndexPath indexPathForRow:0 inSection:0]];

		expect(selection.selection.count).to.equal(1);
		
		indexPath = selection.selection.firstObject;
		expect(indexPath.section).to.equal(1);
		expect(indexPath.row).to.equal(1);
		
		[selection deselect:[NSIndexPath indexPathForRow:1 inSection:1]];
		
		expect(selection.selection.count).to.equal(0);
	});
});

describe(@"Multiple Selection", ^{
	__block BMFDataStoreSelection *selection = nil;
	
	beforeEach(^{
		selection = [BMFDataStoreSelection new];
		selection.mode = BMFDataStoreSelectionModeMultiple;
	});
	
	it(@"should allow multiple selected indexes", ^{
		expect(selection.selection.count).to.equal(0);
		
		[selection select:[NSIndexPath indexPathForRow:0 inSection:0]];
		
		expect(selection.selection.count).to.equal(1);
		
		NSIndexPath *indexPath = selection.selection.firstObject;
		expect(indexPath.section).to.equal(0);
		expect(indexPath.row).to.equal(0);
		
		[selection select:[NSIndexPath indexPathForRow:1 inSection:0]];
		
		expect(selection.selection.count).to.equal(2);
		
		indexPath = selection.selection[1];
		expect(indexPath.section).to.equal(0);
		expect(indexPath.row).to.equal(1);
		
		[selection select:[NSIndexPath indexPathForRow:1 inSection:1]];
		
		expect(selection.selection.count).to.equal(3);
		
		indexPath = selection.selection[2];
		expect(indexPath.section).to.equal(1);
		expect(indexPath.row).to.equal(1);
		
		[selection select:[NSIndexPath indexPathForRow:3 inSection:1]];
		
		expect(selection.selection.count).to.equal(4);
		
		indexPath = selection.selection[3];
		expect(indexPath.section).to.equal(1);
		expect(indexPath.row).to.equal(3);
	});

	it(@"should deselect elements correctly", ^{
		expect(selection.selection.count).to.equal(0);
		
		[selection select:[NSIndexPath indexPathForRow:0 inSection:0]];
		
		expect(selection.selection.count).to.equal(1);
		
		NSIndexPath *indexPath = selection.selection.firstObject;
		expect(indexPath.section).to.equal(0);
		expect(indexPath.row).to.equal(0);
		
		[selection select:[NSIndexPath indexPathForRow:1 inSection:0]];
		
		expect(selection.selection.count).to.equal(2);
		
		indexPath = selection.selection[1];
		expect(indexPath.section).to.equal(0);
		expect(indexPath.row).to.equal(1);

		[selection deselect:[NSIndexPath indexPathForRow:1 inSection:0]];
		
		expect(selection.selection.count).to.equal(1);
		
		indexPath = selection.selection.firstObject;
		expect(indexPath.section).to.equal(0);
		expect(indexPath.row).to.equal(0);
		
		[selection deselect:[NSIndexPath indexPathForRow:0 inSection:0]];

		expect(selection.selection.count).to.equal(0);
		
		[selection select:[NSIndexPath indexPathForRow:0 inSection:0]];

		expect(selection.selection.count).to.equal(1);
		
		indexPath = selection.selection.firstObject;
		expect(indexPath.section).to.equal(0);
		expect(indexPath.row).to.equal(0);
	});

});

SpecEnd