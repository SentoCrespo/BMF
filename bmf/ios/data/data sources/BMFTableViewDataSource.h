//
//  TNTableDataSource.h
//  DataSources
//
//  Created by José Manuel Sánchez on 21/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMFDataSource.h"

#import "BMFCellRegisterProtocol.h"
#import "BMFViewRegisterProtocol.h"

typedef void (^BMFTableViewCellConfigureBlock)(id cell, id item);
typedef void (^BMFTableViewItemDeletedBlock)(id item, NSIndexPath *indexPath);

@interface BMFTableViewDataSource : BMFDataSource <UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic, copy) BMFCompletionBlock dataChangedBlock;

//@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) id<BMFCellRegisterProtocol> cellRegister;
@property (nonatomic, strong) id<BMFViewRegisterProtocol> viewRegister;

/// NO by default. Enable this to allow editing the items in the table. Important: The data store of this data source has to support the protocol BMFDataStoreProtocol or this will throw an exception
@property (nonatomic, assign) BOOL allowEditing;

@property (nonatomic, copy) BMFTableViewItemDeletedBlock itemDeletedBlock;

/// UITableViewCellSelectionStyleDefault by default. In this case it won't be changed
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;

/// Removed. Instead, make a subclass of BMFCellConfigurator and register it in the +(void)load method
//@property (nonatomic, copy) BMFTableViewCellConfigureBlock configureCellBlock;

/// Use animatedUpdates only if the change rate is slow
- (instancetype) initWithDataStore:(id<BMFDataReadProtocol>)dataStore animatedUpdates:(BOOL) animatedUpdates;

@end
