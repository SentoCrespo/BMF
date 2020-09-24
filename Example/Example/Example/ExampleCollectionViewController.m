//
//  ExampleCollectionViewController.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 16/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "ExampleCollectionViewController.h"

#import "BMFArrayProxy.h"
#import "BMFScrollHidesNavigationBarBehavior.h"

#import "BMFIOSDefaultFactory.h"

#import "UILabel+BMF.h"

#import "BMFArrayDataStore.h"

#import "BMFSimpleViewRegister.h"

#import "ExampleHeaderView.h"

#import "BMFCollectionViewDataSource.h"

#import "BMFHomeScreenItemCell.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ExampleCollectionViewController ()

@end

@implementation ExampleCollectionViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Collection";
	
//	BMFScrollHidesNavigationBarBehavior *behavior = [[BMFScrollHidesNavigationBarBehavior alloc] initWithView:self.collectionView];
//	[self.collectionDelegateProxy addDestinationObject:behavior];
//	[self addBehavior:behavior];
	
	BMFIOSDefaultFactory *factory = (BMFIOSDefaultFactory *)[BMFBase sharedInstance].factory;
	
	NSArray *words = @[ @"Blah", @"Blih", @"Bluh",@"b",@"ladjfslk asdf" ];
	
	NSMutableArray *finalWords = [NSMutableArray array];
	for (int i=0;i<10000;i++) {
		[finalWords addObject:words[i%(words.count)]];
	}
	
	BMFArrayDataStore *dataStore = (BMFArrayDataStore *)[factory dataStoreWithParameter:finalWords sender:self];
	dataStore.sectionHeaderTitle = @"Cabeceraaaa";
	dataStore.sectionFooterTitle = @"Pie";

	self.dataSource = (id)[factory collectionViewDataSourceWithStore:dataStore cellClassOrNib:[BMFHomeScreenItemCell class] sender:self];
	
	
	
/*	self.dataSource = [factory tableViewDataSourceWithStore:dataStore cellClassOrNib:[UITableViewCell class] animatedUpdates:NO sender:self];
	
//	BMFSimpleViewRegister *viewRegister = [[BMFSimpleViewRegister alloc] initWithInfos:@[ [[BMFViewRegisterInfo alloc] initWithId:@"Header" kind:BMFViewKindSectionHeader classOrUINib:[ExampleHeaderView class]] ]];

	self.dataSource.cellRegister =
	
	self.dataSource.viewRegister = viewRegister;*/
}

@end
