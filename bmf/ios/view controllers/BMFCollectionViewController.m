//
//  BMFCollectionViewController.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 06/02/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFCollectionViewController.h"

#import "BMFCollectionViewDataSource.h"

#import "UICollectionView+BMF.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BMFCollectionViewController ()

@end

@implementation BMFCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	__weak BMFCollectionViewController *wself = self;
	
	[[RACObserve(self, dataSource) scanWithStart:nil reduce:^id(id<BMFDataSourceProtocol,BMFViewControllerBehaviorProtocol> running, id next) {
		running.view = nil;
		if (running) [wself removeBehavior:running];
		return next;
	}] subscribeNext:^(id x) {
		wself.collectionView.dataSource = x;
		if (x) [wself addBehavior:x];
		wself.dataSource.view = wself.collectionView;
		wself.dataSource.controller = wself;
	}];
	
	if (self.collectionView) [self.BMF_proxy makeDelegateOf:self.collectionView withSelector:@selector(setDelegate:)];
	
	if (self.didLoadBlock) self.didLoadBlock(nil);
	
	BMFAssertReturn(self.collectionView);
}

- (void) setCollectionView:(UICollectionView *)collectionView {
	_collectionView = collectionView;

	if (_collectionView) [self.BMF_proxy makeDelegateOf:_collectionView withSelector:@selector(setDelegate:)];
}

@end
