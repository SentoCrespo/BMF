//
//  TNArrayDataStore.h
//  DataSources
//
//  Created by José Manuel Sánchez on 22/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFNode.h"
#import "BMFDataStore.h"

@interface BMFArrayDataStore : BMFDataStore

@property (nonatomic, copy) NSString *sectionHeaderTitle;
@property (nonatomic, copy) NSString *sectionFooterTitle;

- (NSArray *) allItems;

/// This should only be used by subclasses
@property (nonatomic, strong) NSMutableArray *storedItems;

@end
