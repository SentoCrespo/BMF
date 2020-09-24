//
//  TNViewDataSourceProtocol.h
//  DataSources
//
//  Created by José Manuel Sánchez on 24/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFDataReadProtocol.h"

#import "BMFProgress.h"

typedef void(^BMFConfigureViewBlock)(id configurator,id view);

@protocol BMFDataSourceProtocol <NSObject, BMFDataReadProtocol>

/// Reference to the view controller or other object that acts as such. This can be used as the delegate of the actions of a cell, for example
@property (nonatomic, weak) id controller;

@property (nonatomic, strong) id<BMFDataStoreSelectionProtocol> selection;

@property (nonatomic, strong) id<BMFDataReadProtocol> dataStore;

@property (nonatomic, copy) BMFCompletionBlock dataChangedBlock;

@property (nonatomic, copy) BMFConfigureViewBlock willConfigureViewBlock;
@property (nonatomic, copy) BMFActionBlock didConfigureViewBlock;

@property (nonatomic, weak) BMFIXView *view;

@end
