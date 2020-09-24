//
//  BMFSqliteConfiguration.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 05/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFFMDBConfiguration.h"

#import "BMFUtils.h"
#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabase.h>
@implementation BMFFMDBConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.databaseName = @"bmf_db.sqlite";
		self.databasePath = [BMFUtils applicationDocumentsDirectory];
    }
    return self;
}

- (BOOL) setup {
	if (![super setup]) return NO;
	
	BOOL result = [self loadDB];
	
	return result;
}

- (void) tearDown {
	[super tearDown];
	
	[self closeDB];
}

- (BOOL) loadDB {
	
	NSString *dbPath = [self.databasePath stringByAppendingPathComponent:self.databaseName];
	@try {
		self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
		if (!self.databaseQueue) {
			DDLogError(@"Error: couldn't open database");
			return NO;
		}
		else {
			
			if (self.traceExecution) {
				[self.databaseQueue inDatabase:^(FMDatabase *db) {
					db.traceExecution = self.traceExecution;
				}];
			}
			
			return YES;
		}
	}
	@catch (NSException *exception) {
		DDLogError(@"Exception opening database: %@",exception);
	}
	
	return NO;
}

- (BOOL) initDB {
	return NO;
}

- (void) closeDB {
	[self.databaseQueue close];
}

@end