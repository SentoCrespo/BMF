//
//  NSOrderedSet+BMF.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 4/2/15.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"

@interface NSOrderedSet (BMF)

- (void) BMF_forEach:(BMFItemBlock)block;
- (NSOrderedSet *) BMF_map:(BMFMapBlock)block;
- (NSOrderedSet *) BMF_filter:(BMFFilterBlock)block;
- (id) BMF_findFirst:(BMFFilterBlock)block;

@end
