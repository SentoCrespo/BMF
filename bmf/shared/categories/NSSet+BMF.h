//
//  NSSet+BMF.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/1/15.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"

@interface NSSet (BMF)

- (void) BMF_forEach:(BMFItemBlock)block;
- (NSSet *) BMF_map:(BMFMapBlock)block;
- (NSSet *) BMF_filter:(BMFFilterBlock)block;
- (NSArray *) BMF_randomSubsetWithElementCount:(NSUInteger)count;
- (id) BMF_findFirst:(BMFFilterBlock)block;

@end
