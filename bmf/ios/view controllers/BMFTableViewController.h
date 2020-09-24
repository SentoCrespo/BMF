//
//  TRNTableViewController.h
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 13/12/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMFViewController.h"
#import "BMFViewControllerDataSourceProtocol.h"
#import "BMFDataSourceProtocol.h"

#import "BMFArrayProxy.h"

@interface BMFTableViewController : BMFViewController <BMFViewControllerDataSourceProtocol>

@property (nonatomic, strong) id<BMFDataSourceProtocol> dataSource;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL hidesSeparatorsForEmptyCells;

//@property (nonatomic, strong) BMFArrayProxy *tableDelegateProxy;

@end
