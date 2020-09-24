//
//  BMFSqliteConfiguration.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 05/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFDefaultConfiguration.h"

@class FMDatabaseQueue;

@interface BMFFMDBConfiguration : BMFDefaultConfiguration


/// Optional method. If no name is set bmf_db.sqlite will be used
@property (nonatomic, strong) NSString *databaseName;

/// Optional method. If no path is set the documents path will be used
@property (nonatomic, strong) NSString *databasePath;

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@property (nonatomic, assign) BOOL traceExecution;

@end
