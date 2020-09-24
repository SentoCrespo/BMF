//
//  TRNTableViewController.m
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 13/12/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFTableViewController.h"

#import "BMFTableViewDataSource.h"

#import "UITableView+BMF.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface BMFTableViewController () <UITableViewDelegate>

@end

@implementation BMFTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	@weakify(self);
	[[RACObserve(self, dataSource) combinePreviousWithStart:nil reduce:^id(id<BMFDataSourceProtocol,BMFViewControllerBehaviorProtocol> previous, id current) {
		@strongify(self);;
		previous.view = nil;
		if (previous) [self removeBehavior:previous];
		return current;
	}] subscribeNext:^(id x) {
		@strongify(self);
		if (!x) return;
		[self addBehavior:x];
		self.dataSource.controller = self;
		self.dataSource.view = self.tableView;
	}];
	
	if (self.tableView) [self.BMF_proxy makeDelegateOf:self.tableView withSelector:@selector(setDelegate:)];
	
	self.hidesSeparatorsForEmptyCells = YES;
	
	if (self.didLoadBlock) self.didLoadBlock(self);
}

#pragma mark Accessors

- (void) setTableView:(UITableView *)tableView {
	_tableView = tableView;
	if (_tableView) [self.BMF_proxy makeDelegateOf:_tableView withSelector:@selector(setDelegate:)];
}

- (void) setHidesSeparatorsForEmptyCells:(BOOL)hidesSeparatorsForEmptyCells {
	_hidesSeparatorsForEmptyCells = hidesSeparatorsForEmptyCells;
	
	if ([self isViewLoaded]) [self hideSeparatorsForEmptyCells];
}

- (void) hideSeparatorsForEmptyCells {
	if (self.hidesSeparatorsForEmptyCells) {
		UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
		self.tableView.tableFooterView = footer;
	}
	else {
		self.tableView.tableFooterView = nil;
	}
}

@end
