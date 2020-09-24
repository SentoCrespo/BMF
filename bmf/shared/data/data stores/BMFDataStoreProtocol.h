//
//  TNDataStoreProtocol.h
//  DataSources
//
//  Created by José Manuel Sánchez on 22/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"
#import "BMFValueProtocol.h"

@protocol BMFDataStoreProtocol <NSObject, BMFValueChangeNotifyProtocol>

- (void) startUpdating;
- (BOOL) addItem:(id) item;
- (BOOL) insertItem:(id) item atIndexPath:(NSIndexPath *) indexPath;
- (BOOL) removeItem:(id) item;
- (void) endUpdating;

- (void) removeAllItems;

@optional

- (void) setItems:(id) items;

@end
