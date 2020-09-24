//
//  NSMutableOrderedSet+BMF.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/2/15.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"

@interface NSMutableOrderedSet (BMF)

- (void) BMF_addObjectSafe:(id) object;

- (void) BMF_forEach:(BMFItemBlock)block;
- (NSMutableOrderedSet *) BMF_map:(BMFMapBlock)block;
- (NSMutableOrderedSet *) BMF_filter:(BMFFilterBlock)block;

@end
