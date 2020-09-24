//
//  NSDate+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/1/15.
//
//

#import "NSDate+BMF.h"

@implementation NSDate (BMF)

- (BOOL) BMF_earlierThan:(NSDate *) date {
	return [self compare:date]==NSOrderedAscending;
}

- (BOOL) BMF_earlierOrEqualThan:(NSDate *) date {
	NSComparisonResult result = [self compare:date];
	return (result==NSOrderedAscending || result==NSOrderedSame);
}

- (BOOL) BMF_laterThan:(NSDate *) date {
	return [self compare:date]==NSOrderedDescending;
}

- (BOOL) BMF_laterOrEqualThan:(NSDate *) date {
	NSComparisonResult result = [self compare:date];
	return (result==NSOrderedDescending || result==NSOrderedSame);
}

@end
