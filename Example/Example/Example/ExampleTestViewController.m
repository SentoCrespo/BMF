//
//  BMFTestViewController.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "ExampleTestViewController.h"

#import "BMFArrayProxy.h"
#import "BMFScrollHidesNavigationBarBehavior.h"
#import "BMFItemTapBlockBehavior.h"

#import "BMFIOSDefaultFactory.h"

#import "UILabel+BMF.h"

#import "BMFArrayDataStore.h"

#import "BMFSimpleViewRegister.h"

#import "ExampleHeaderView.h"

#import "BMFTableViewDataSource.h"

#import <BMF/BMF.h>
#import <BMF/BMFImageBannerViewController.h>
#import <BMF/BMFBannerImage.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <BMF/BMFAudioRecordActivity.h>

#import "ExampleDragDropCollectionViewsViewController.h"

@interface ExampleTestViewController ()

@end

@implementation ExampleTestViewController {
	BMFAudioRecordActivity *audioRecord;
}

@synthesize label;

- (void) viewDidLoad {
	[super viewDidLoad];
	
	ExampleDragDropCollectionViewsViewController *ddVC = [ExampleDragDropCollectionViewsViewController new];
	[self presentViewController:ddVC animated:YES completion:nil];
	
//	BMFAudioRecordViewController *audioRecorder = [BMFAudioRecordViewController new];
//	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:audioRecorder];
//	[self presentViewController:navController animated:YES completion:nil];
//	audioRecord = [BMFAudioRecordActivity new];
//	audioRecord.viewController = self;
//	[audioRecord run:^(id result, NSError *error) {
//		if (result) DDLogDebug(@"audio recorded");
//		else DDLogError(@"%@",error);
//	}];
	
	
	BMFImageBannerViewController *bannerVC = [BMFImageBannerViewController new];
	[self BMF_addChild:bannerVC addSubviewBlock:^(id sender) {
		[self.bannerView addSubview:bannerVC.view];
		[BMFAutoLayoutUtils fill:self.bannerView with:bannerVC.view margin:0];
	}];
	
	bannerVC.items = @[
					   [[BMFBannerImage alloc] initWithUrlString:@"http://media.nbcdfw.com/images/654*368/oak-tree.jpg"],
   					   [[BMFBannerImage alloc] initWithUrlString:@"http://levoleague-wordpress.s3.amazonaws.com/wp-content/uploads/2013/04/Career-Path-Like-Climbing-Tree.jpg"],
   					   [[BMFBannerImage alloc] initWithUrlString:@"http://www.growingagreenerworld.com/wp-content/uploads/2011/09/212-Tree-Majestic.jpg"]
					   ];
	
	
	BMFScrollHidesNavigationBarBehavior *behavior = [[BMFScrollHidesNavigationBarBehavior alloc] initWithView:self.tableView];
	[self addBehavior:behavior];

	BMFItemTapBlockBehavior *tapBehavior = [[BMFItemTapBlockBehavior alloc] initWithView:self.tableView tapBlock:^(id item, NSIndexPath *indexPath) {
		[self performSegueWithIdentifier:@"collection" sender:self];
	}];
	
	
//	[[BMFItemTapBlockBehavior alloc] initWithTapBlock:^(id sender,NSIndexPath *indexPath) {
//		[self performSegueWithIdentifier:@"collection" sender:sender];
//	}];
	[self addBehavior:tapBehavior];
	
	BMFIOSDefaultFactory *factory = (BMFIOSDefaultFactory *)[BMFBase sharedInstance].factory;
	
	NSArray *words = @[ @"Blah", @"Blih", @"Bluh",@"b",@"ladjfslk asdf" ];
	
	NSMutableArray *finalWords = [NSMutableArray array];
	for (int i=0;i<10000;i++) {
		[finalWords addObject:words[i%(words.count)]];
	}
	
	BMFArrayDataStore *dataStore = (BMFArrayDataStore *)[factory dataStoreWithParameter:finalWords sender:self];
	dataStore.sectionHeaderTitle = @"Cabeceraaaa";
	dataStore.sectionFooterTitle = @"Pie";
	
	self.dataSource = [factory tableViewDataSourceWithStore:dataStore cellClassOrNib:[UITableViewCell class] animatedUpdates:NO sender:self];
	
	BMFSimpleViewRegister *viewRegister = [[BMFSimpleViewRegister alloc] initWithInfos:@[ [[BMFViewRegisterInfo alloc] initWithId:@"Header" kind:BMFViewKindSectionHeader classOrUINib:[ExampleHeaderView class]] ]];
	
	((BMFTableViewDataSource *)self.dataSource).viewRegister = viewRegister;
	
	[[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
		CGFloat size = arc4random()%60;
		[self.label BMF_setFontSizeWithAnimation:size duration:1];
	}];
	
//	[self.tableDelegateProxy addDestinationObject:self.dataSource];
	
//	self.tableView.delegate = (id)proxy;

//	self.dataSource = [factory tableViewControllerWithArray:@[ @"Blah", @"Blih", @"Bluh" ] cellClassOrNib:[UITableView class] sender:self];
}

@end
