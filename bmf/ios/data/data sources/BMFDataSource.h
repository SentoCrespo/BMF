//
//  BMFDataSource.h
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 04/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFDataSourceProtocol.h"
#import "BMFDataReadProtocol.h"

@interface BMFDataSource : NSObject <BMFDataSourceProtocol,BMFDataReadProtocol>

@property (nonatomic, strong) BMFActionBlock applyValueBlock;
@property (nonatomic, strong) BMFActionBlock signalBlock;

/// This can be used as the delegate of the actions of a cell, for example
@property (nonatomic, weak) id controller;

@property (nonatomic, strong) BMFProgress *progress;

@property (nonatomic, strong) id<BMFDataReadProtocol> dataStore;
@property (nonatomic, copy) BMFCompletionBlock dataChangedBlock;

@property (nonatomic, strong) id<BMFDataStoreSelectionProtocol> selection;

@property (nonatomic, copy) BMFConfigureViewBlock willConfigureViewBlock;
@property (nonatomic, copy) BMFActionBlock didConfigureViewBlock;

- (instancetype) initWithDataStore:(id<BMFDataReadProtocol>) dataStore;
- (instancetype) init __attribute__((unavailable("Use initWithDataStore instead")));

@property (nonatomic, weak) BMFIXView *view;

/// Returns YES if the indexPath will return an object. If it returns no and you try to get that item the data source will throw an exception
- (BOOL) indexPathInsideBounds:(NSIndexPath *) indexPath;

/// For subclasses
- (void) notifyDataChanged;

@end
