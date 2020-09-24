//
//  BMFFMDBDataStore.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 05/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFDataStore.h"

#import "BMFDataReadProtocol.h"
#import "BMFFMDBModelProtocol.h"

#import <FMDB/FMDatabase.h>

@class FMDatabase;

@interface BMFFMDBDataStore : BMFDataStore <BMFDataReadProtocol>

@property (nonatomic, copy) NSString *query;
@property (nonatomic, copy) NSArray *parameters;

@property (nonatomic, strong) Class<BMFFMDBModelProtocol> modelClass;
@property (nonatomic, copy) NSDictionary *modelParameters;

@property (nonatomic, copy) NSString *sectionHeaderTitle;
@property (nonatomic, copy) NSString *sectionFooterTitle;

- (instancetype)initWithQuery:(NSString *)query parameters:(NSArray *) parameters modelClass:(Class<BMFFMDBModelProtocol>)modelClass;
- (instancetype) init __attribute__((unavailable("Use initWithDataStore instead")));

@property (nonatomic, readonly) BOOL loaded;

- (BOOL) loadData:(BMFCompletionBlock) completionBlock;

@end
