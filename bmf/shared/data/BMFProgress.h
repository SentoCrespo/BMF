//
//  TNProgress.h
//  DataSources
//
//  Created by José Manuel Sánchez on 12/11/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"

@interface BMFProgress : NSObject

@property (nonatomic,readonly) BOOL started;
@property (nonatomic,readonly) BOOL running;

@property (assign, nonatomic) NSTimeInterval estimatedTime; // This allows to compare progress units accross objects

@property (assign, nonatomic) NSTimeInterval totalUnitCount;
@property (assign, nonatomic) NSTimeInterval completedUnitCount;

@property (readonly, nonatomic) CGFloat fractionCompleted;

/// Provides information about the progress or the failure of the task
@property (nonatomic, copy) NSString *progressMessage;

/// If fractionCompleted is 1 and the operation was not successful, here you can find the error
@property (nonatomic, strong) NSError *failedError;

@property (nonatomic, readonly) NSHashTable *children;

/// Block to perform some action when progress changes. Passes itself as the sender
@property (nonatomic, copy) BMFActionBlock changedBlock;

/// This key is used to identify the task. The estimated time will be averaged based on it
@property (nonatomic, strong) NSString *key;

/// Clears completed, total unit counts and estimated time
- (void) clear;

/// Clears the progress and removes all children
- (void) reset;

- (void) addChild:(BMFProgress *) child;
- (void) removeChild:(BMFProgress *) child;

- (void) start;
- (void) start:(NSString *) key;
- (void) stop: (NSError *) error;

@end
