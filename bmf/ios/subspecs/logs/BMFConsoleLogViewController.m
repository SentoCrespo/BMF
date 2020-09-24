//
//  BMFConsoleLogViewController.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 29/08/14.
//
//

#import "BMFConsoleLogViewController.h"

#import "BMFConsoleLogDetailViewController.h"

#import "BMF.h"
#import "BMFArrayDataStore.h"
#import "BMFItemTapBlockBehavior.h"

#import <JMSLogger/JMSLogger.h>

@interface BMFConsoleLogViewController ()

@property (nonatomic, strong) BMFArrayDataStore *dataStore;

@property (nonatomic, assign) NSInteger logContextFilter;
@property (nonatomic, assign) NSInteger logLevelFilter;

@end

@implementation BMFConsoleLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = BMFLocalized(@"Log", nil);
	
	self.logContextFilter = -1;
	self.logLevelFilter = DDLogLevelAll;
	
	self.dataStore = [[BMFArrayDataStore alloc] init];
	
	self.dataSource = [[BMFBase sharedInstance].factory tableViewDataSourceWithStore:self.dataStore cellClassOrNib:[UINib nibWithNibName:@"BMFConsoleLogTableViewCell" bundle:nil] animatedUpdates:NO sender:nil];
	
	BMFItemTapBlockBehavior *tapBehavior = [[BMFItemTapBlockBehavior alloc] initWithTapBlock:^(id item, NSIndexPath *indexPath) {
		BMFConsoleLogDetailViewController *detailVC = [BMFConsoleLogDetailViewController new];
		detailVC.objectStore.currentValue = item;
		[self.navigationController pushViewController:detailVC animated:YES];
	}];
	[self addBehavior:tapBehavior];
}

- (void) reload {
	JMSLogger *logger = [JMSLogger new];
	if (self.logContextFilter==-1) {
		self.dataStore.items = [logger logMessagesWithLevel:self.logLevelFilter];
	}
	else {
		self.dataStore.items = [logger logMessagesWithLevel:self.logLevelFilter context:self.logContextFilter];
	}
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	BMFAssertReturn(self.navigationController);
	
	[self reload];
}

@end
