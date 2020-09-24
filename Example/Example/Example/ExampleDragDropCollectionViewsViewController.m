//
//  ExampleDragDropCollectionViewsViewController.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/08/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "ExampleDragDropCollectionViewsViewController.h"

#import <BMF/BMFCollectionViewDataSource.h>
#import <BMF/BMFCollectionViewDragDropBehavior.h>
#import <BMF/BMFCompoundDataStore.h>

#import "BMFStringCollectionViewCell.h"


@implementation ExampleDragDropCollectionViewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	id bottomDataStore = [[BMFBase sharedInstance].factory dataStoreWithParameter:@[ @"1",@"2",@"3",@"4",@"5" ] sender:nil];
	
	id left1DataStore = [[BMFBase sharedInstance].factory dataStoreWithParameter:@[ @"hola1",@"hola2",@"hola3" ] sender:nil];
	id left2DataStore = [[BMFBase sharedInstance].factory dataStoreWithParameter:@[ @"hola4",@"hola5" ] sender:nil];
	id leftDataStore = [[BMFCompoundDataStore alloc] initWithStores:@[ left1DataStore, left2DataStore ]];

	id rightDataStore = [[BMFBase sharedInstance].factory dataStoreWithParameter:@[ @"adios1",@"adios2",@"adios3",@"adios4",@"adios5" ] sender:nil];

	id<BMFDataSourceProtocol> bottomDataSource = [[BMFBase sharedInstance].factory collectionViewDataSourceWithStore:bottomDataStore cellClassOrNib:[BMFStringCollectionViewCell class] sender:self];
	bottomDataSource.view = self.bottomCollectionView;
	
	id<BMFDataSourceProtocol> leftDataSource = [[BMFBase sharedInstance].factory collectionViewDataSourceWithStore:leftDataStore cellClassOrNib:[BMFStringCollectionViewCell class] sender:self];
	leftDataSource.view = self.leftCollectionView;


	id<BMFDataSourceProtocol> rightDataSource = [[BMFBase sharedInstance].factory collectionViewDataSourceWithStore:rightDataStore cellClassOrNib:[BMFStringCollectionViewCell class] sender:self];
	rightDataSource.view = self.rightCollectionView;

	
	id dragDropBehavior = [[BMFCollectionViewDragDropBehavior alloc] initWithCollectionViews:@[ self.leftCollectionView, self.rightCollectionView, self.bottomCollectionView ]];
	[self addBehavior:dragDropBehavior];
}


@end
