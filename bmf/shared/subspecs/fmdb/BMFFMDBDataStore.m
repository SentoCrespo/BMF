//
//  BMFFMDBDataStore.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 05/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFFMDBDataStore.h"

#import <FMDB/FMDatabaseQueue.h>
#import "BMFFMDBConfiguration.h"
#import "BMF.h"

@interface BMFFMDBDataStore ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) FMDatabaseQueue *databaseQueue;

@end

@implementation BMFFMDBDataStore

@synthesize progress = _progress;

- (instancetype)initWithQuery:(NSString *)query parameters:(NSArray *)parameters modelClass:(Class<BMFFMDBModelProtocol>)modelClass {
	
	BMFAssertReturnNil(query);
	BMFAssertReturnNil(modelClass);
		
	BMFFMDBConfiguration *config = [BMFFMDBConfiguration BMF_cast:[BMFBase sharedInstance].config];
	BMFAssertReturnNil(config);
	
	self.databaseQueue = config.databaseQueue;
	
    self = [super init];
    if (self) {
		_query = query;
		_parameters = parameters;
		_modelClass = modelClass;
		_progress = [BMFProgress new];
		[self loadData:nil];
    }
    return self;
}

- (NSInteger) numberOfSections {
	return 1;
}

- (NSInteger) numberOfRowsInSection:(NSUInteger) section {
	return self.items.count;
}

- (NSString *) titleForSection:(NSUInteger)section kind:(NSString *)kind {
	if ([kind isEqualToString:BMFViewKindSectionHeader]) return self.sectionHeaderTitle;
	return self.sectionFooterTitle;
}

- (id) itemAt:(NSInteger) section row:(NSInteger) row {
	BMFAssertReturnNil(row>=0);
	BMFAssertReturnNil(row<self.items.count);
	BMFAssertReturnNil(section==0);
	
	return self.items[row];
}

- (id) itemAt:(NSIndexPath *) indexPath {
	return [self itemAt:indexPath.BMF_section row:indexPath.BMF_row];
}

- (NSIndexPath *) indexOfItem:(id) item {
	NSUInteger row = [self.allItems indexOfObject:item];
	if (row==NSNotFound) return nil;
	
	return [NSIndexPath BMF_indexPathForRow:row inSection:0];
}

- (NSArray *) allItems {
	return self.items;
}

- (void) reload {
	[self loadData:nil];
}

- (BOOL) loadData:(BMFCompletionBlock) completionBlock {
	NSError *error = nil;

	NSMutableArray *fetchedItems = [NSMutableArray array];
	
	[self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
		FMResultSet *set = [db executeQuery:self.query withArgumentsInArray:self.parameters];
		while([set next]) {
			if ([self.modelClass respondsToSelector:@selector(BMF_entityWithSet:parameters:)]) {
				[fetchedItems addObject:[self.modelClass BMF_entityWithSet:set  parameters:self.modelParameters]];
			}
			else {
				[fetchedItems addObject:[self.modelClass BMF_entityWithSet:set]];				
			}
		}
	}];
	
	self.items = [fetchedItems copy];
	
	BOOL result = NO;
	
	if (result) _loaded = YES;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataBatchChangeNotification object:self];
	
	if (completionBlock) completionBlock(self.items,error);
	
	return result;
}

- (BOOL) isEmpty {
	return self.allItems.count==0;
}

@end
