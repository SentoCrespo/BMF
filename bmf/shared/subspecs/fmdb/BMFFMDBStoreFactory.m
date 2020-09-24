//
//  BMFFMDBStoreFactory.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 31/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFFMDBStoreFactory.h"

#import "BMFFMDBDataStore.h"

@implementation BMFFMDBStoreFactory

+ (void)load {
	[self register];
}

- (id<BMFDataReadProtocol>) dataStoreWithParameter:(id) input sender:(id) sender {
	return nil;
}

- (id<BMFDataReadProtocol>) dataStoreWithParameters:(NSArray *) parameters sender:(id) sender {
	if (parameters.count!=3) return nil;

	if ([parameters[0] isKindOfClass:[NSString class]] && [parameters[1] isKindOfClass:[NSArray class]] && [parameters[2] conformsToProtocol:@protocol(BMFFMDBModelProtocol)]) {
		return [self fmdbDataStore:parameters[0] parameters:parameters[1] modelClass:parameters[2]];
	}

	return nil;
}


- (id<BMFDataReadProtocol>) fmdbDataStore:(NSString *) query parameters:(NSArray *) parameters modelClass:(id<BMFFMDBModelProtocol>) modelClass{
	return [[BMFFMDBDataStore alloc] initWithQuery:query parameters:parameters modelClass:modelClass];
}



@end
