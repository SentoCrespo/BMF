//
//  BMFFMDBObject.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 17/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFFMDBObject.h"
#import "BMFFMDBConfiguration.h"

#import "BMF.h"

#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabase.h>

@implementation BMFFMDBObject

+ (FMDatabaseQueue *) BMF_databaseQueue {
	BMFFMDBConfiguration *config = [BMFFMDBConfiguration BMF_cast:[BMFBase sharedInstance].factory];
	BMFAssertReturnNil(config);
//	if (!config) {
//		[NSException raise:@"BMFFMDBObject requires a BMFFMDBConfiguration in BMFBase" format:@"%@",[BMFBase sharedInstance].factory];
//		return NO;
//	}
		
	return config.databaseQueue;
}

+ (BOOL) BMF_deleteAll {
	
	__block BOOL result = NO;
	
	FMDatabaseQueue *queue = [self BMF_databaseQueue];
	[queue inDatabase:^(FMDatabase *db) {
		NSString *query = [NSString stringWithFormat:@"delete from %@;",self.BMF_tableName];
		result = [db executeUpdate:query];
	}];
	
	return result;
}

+ (NSArray *) BMF_findAll {
	return [self BMF_findAll:nil arguments:nil];
}

+ (NSArray *) BMF_findAll:(NSString *) whereClause arguments:(NSArray *) arguments {
	return [self BMF_findAll:nil arguments:nil orderByClause:nil];
}


+ (NSArray *) BMF_findAll:(NSString *) whereClause arguments:(NSArray *) arguments orderByClause:(NSString *) orderBy {
	__block FMResultSet *rs = nil;
	FMDatabaseQueue *queue = [self BMF_databaseQueue];
	
	[queue inDatabase:^(FMDatabase *db) {
		NSMutableString *query = [NSMutableString stringWithString:@"select * from "];
		[query appendString:self.BMF_tableName];
		if (whereClause.length>0) {
			[query appendString:@" where "];
			[query appendString:whereClause];
		}
		
		if (orderBy.length>0) {
			[query appendString:@" order by "];
			[query appendString:orderBy];
		}
		
		rs = [db executeQuery:query withArgumentsInArray:arguments];
	}];
	
	NSMutableArray *results = [NSMutableArray array];
	while ([rs next]) {
		id entity = [self BMF_entityWithResultSet:rs];
		if (entity) [results addObject:entity];
	}
	
	return results;
}

+ (instancetype) BMF_entityWithResultSet:(FMResultSet *) rs {
	
	id instance = [self new];
	
	NSArray *properties = [self BMF_propertiesArray];
	if (properties.count>0) {
		for (NSString *propertyName in properties) {
			[instance setValue:[rs valueForKey:propertyName] forKey:propertyName];
		}
	}
	else {
		NSDictionary *dic = [self BMF_propertiesDic];
		if (dic.allKeys.count>0) {
			for (NSString *key in dic.allKeys) {
				NSString *dbPropertyName = dic[key];
				[instance setValue:[rs valueForKey:dbPropertyName] forKey:key];
			}
		}
		else {
			[NSException raise:@"A FMDBObject subclass must implement BMF_propertiesArray or BMF_propertiesDic" format:@"%@",self];
		}
	}
	
	return instance;
}

/*- (BOOL) BMF_insertInDB {
	FMDatabaseQueue *queue = [BMFFMDBObject BMF_databaseQueue];
	[queue inDatabase:^(FMDatabase *db) {
		NSMutableString *query = [NSMutableString string];
		[query appendString:@"insert into "];
		[query appendString:[self.class BMF_tableName]];
		[query appendString:@" ("];
		
		int numParams = 0;

		NSArray *properties = [self.class BMF_propertiesArray];
		if (properties.count>0) {
			
		}
		else {
			NSDictionary *dic = [self.class BMF_propertiesDic];
			if (dic.allKeys.count>0) {
				
			}
		}
		
		
		[query appendString:@") values ("];
		[query appendString:@")"];
		
//		[db executeUpdate:query withParameterDictionary:]
		
		
	}];
}

- (BOOL) BMF_updateInDB {
	
}*/


#pragma mark Template methods

+ (NSString *) BMF_tableName {
	[NSException raise:@"BMF_tableName not implemented" format:@"%@",self];
	return nil;
}



@end
