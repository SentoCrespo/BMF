//
//  NSDate+BMF.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/1/15.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (BMF)

- (BOOL) BMF_earlierThan:(NSDate *) date;
- (BOOL) BMF_earlierOrEqualThan:(NSDate *) date;
- (BOOL) BMF_laterThan:(NSDate *) date;
- (BOOL) BMF_laterOrEqualThan:(NSDate *) date;

@end
