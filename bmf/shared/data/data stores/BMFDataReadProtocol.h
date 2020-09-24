//
//  TNDataReadProtocol.h
//  DataSources
//
//  Created by José Manuel Sánchez on 05/11/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"
#import "BMFProgress.h"
#import "BMFDataStoreSelectionProtocol.h"
#import "BMFValueProtocol.h"

@protocol BMFDataReadProtocol <NSObject, BMFValueChangeNotifyProtocol>

@property (nonatomic, strong) BMFProgress *progress;

- (NSInteger) numberOfSections;
- (NSInteger) numberOfRowsInSection:(NSUInteger) section;
- (NSString *) titleForSection:(NSUInteger) section kind:(NSString *)kind;
- (id) itemAt:(NSInteger) section row:(NSInteger) row;
- (id) itemAt:(NSIndexPath *) indexPath;

- (NSIndexPath *) indexOfItem:(id) item;

- (NSArray *) allItems;

- (BOOL) isEmpty;

- (BOOL) indexPathInsideBounds:(NSIndexPath *) indexPath;

/// Force reload. Run the query against the db again, reload from url, whatever
- (void) reload;

@end
