//
//  NSArray+BMF.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 17/12/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"

typedef id(^BMFArrayItemIdentifierBlock)(id item);
typedef NSString *(^BMFArrayGroupBlock)(id item, NSInteger index);

@interface NSArray (BMF)

- (void) BMF_forEach:(BMFItemBlock)block;
- (id) BMF_reduce:(id) initialValue combine:(BMFCombineBlock)block;
- (NSArray *) BMF_map:(BMFMapBlock)block;
- (NSArray *) BMF_filter:(BMFFilterBlock)block;

/// Flattens an array of arrays to an array of items
- (NSArray *) BMF_flatten;

- (NSArray *) BMF_tail;
- (NSArray *) BMF_arrayByRemovingFirstObject;
- (NSArray *) BMF_arrayByRemovingObjectsAtIndexes:(NSArray *) indexes;
- (NSArray *) BMF_arrayByRemovingLastObject;
- (NSArray *) BMF_arrayByRemovingDuplicates:(BMFArrayItemIdentifierBlock) block;
- (NSArray *) BMF_randomSubarrayWithElementCount:(NSUInteger)count;
- (id) BMF_findFirst:(BMFFilterBlock)block;

- (NSDictionary *) BMF_arrayGroupedBy:(BMFArrayGroupBlock)groupBlock;

@end
