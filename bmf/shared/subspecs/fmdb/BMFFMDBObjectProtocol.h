//
//  BMFFMDBObjectProtocol.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;

@protocol BMFFMDBObjectProtocol <NSObject>
//+ (id) BMF_entityWithResultSet:(FMResultSet *) rs;

+ (BOOL) BMF_deleteAll;

/// Finds all the entities that match whereClause. You must not include 'where'. Example: @"deleted=0"
+ (NSArray *) BMF_findAll;
+ (NSArray *) BMF_findAll:(NSString *) whereClause arguments:(NSArray *) arguments;
+ (NSArray *) BMF_findAll:(NSString *) whereClause arguments:(NSArray *) arguments orderByClause:(NSString *) orderBy;


+ (NSString *) BMF_tableName;


/// BAD: The entity shouldn't save
//- (BOOL) BMF_insertInDB;
//- (BOOL) BMF_updateInDB;

@optional

/// you should implement one or the other. Use array if the property names are the same than in the database
+ (NSArray *) BMF_propertiesArray;
+ (NSDictionary *) BMF_propertiesDic;


@end
