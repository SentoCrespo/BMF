//
//  TNFRDataStore.h
//  DataSources
//
//  Created by José Manuel Sánchez on 05/11/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "BMFDataStore.h"

@interface BMFFRCDataStore : BMFDataStore <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fr;

@property (nonatomic, readonly) BOOL loaded;

- (instancetype)initWithController:(NSFetchedResultsController *)fr;
- (instancetype) init __attribute__((unavailable("Use initWithController: instead")));

@end
