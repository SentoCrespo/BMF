//
//  BMFCompareParserStrategy.m
//  metaBooksCoreData
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/05/14.
//  Copyright (c) 2014 Treenovum. All rights reserved.
//

#import "BMFCompareParserStrategy.h"

#import "BMF.h"

@implementation BMFCompareParserStrategy


- (NSArray *) parseServerObjects:(NSArray *)serverObjects localObjects:(NSArray *)localObjects objectParser:(id<BMFObjectParserProtocol>)objectParser {

	NSMutableArray *results = [NSMutableArray array];
	
	localObjects = [localObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [objectParser compareLocalObject:obj1 withLocalObject:obj2];
	}];
	
	NSArray *sortedServerObjects = [serverObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [objectParser compareServerObject:obj1 withServerObject:obj2];
	}];
	
	NSUInteger index = 0;
	NSUInteger localIndex = 0;
	NSUInteger serverIndex = 0;
	
	NSError *error = nil;
	
	while (localIndex<localObjects.count && serverIndex<sortedServerObjects.count) {
		id localEntity = localObjects[localIndex];
		
		id serverEntityObject = sortedServerObjects[serverIndex];
		
		NSComparisonResult comparisonResult = [objectParser compareLocalObject:localEntity withServerObject:serverEntityObject];
		
		if (comparisonResult==NSOrderedAscending) {
			BOOL shouldDelete = YES;
			if ([self.delegate respondsToSelector:@selector(shouldDeleteObject:)] && ![self.delegate shouldDeleteObject:localEntity]) shouldDelete = NO;
			if (shouldDelete) {
				[objectParser deleteObject:localEntity];
				if ([self.delegate respondsToSelector:@selector(didDeleteObject:)]) [self.delegate didDeleteObject:localEntity];
			}
			
			localIndex++;
		}
		else {
			
			id entity = localEntity;
			
			if (comparisonResult==NSOrderedDescending) {
				// Add object
				entity = nil;
			}
			else {
				localIndex++;
			}
			
			serverIndex++;
			
			if (!entity) {
				BOOL createObject = YES;
				if ([self.delegate respondsToSelector:@selector(shouldCreateObjectForServerObject:)] && ![self.delegate shouldCreateObjectForServerObject:serverEntityObject]) createObject = NO;
				
				if (createObject) {
					entity = [objectParser newObjectFromServerObject:serverEntityObject];
					if ([self.delegate respondsToSelector:@selector(didCreateObject:)]) [self.delegate didCreateObject:entity];
				}
			}
			
			BOOL result = [objectParser updateLocalObject:entity withServerObject:serverEntityObject error:&error];
			if (!result) {
				if ([self.delegate respondsToSelector:@selector(didFailToParseObject:withServerObject:)]) [self.delegate didFailToParseObject:entity withServerObject:serverEntityObject];
				entity = nil;
				DDLogError(@"Error updating object: %@",error);
			}
			else {
				if ([self.delegate respondsToSelector:@selector(didParseObject:withServerObject:)]) [self.delegate didParseObject:entity withServerObject:serverEntityObject];
			}
			
			if (entity) {
				[results addObject:entity];
			}
			else {
				DDLogError(@"Error updating entity: %@",error);
			}
		}
		
		index++;
		
		if (index%self.batchSize==0) {
			[objectParser saveChanges];
		}
	}
	
	// Delete all these objects
	while (localIndex<localObjects.count) {
		id localEntity = localObjects[localIndex];
		BOOL shouldDelete = YES;
		if ([self.delegate respondsToSelector:@selector(shouldDeleteObject:)] && ![self.delegate shouldDeleteObject:localEntity]) shouldDelete = NO;
		if (shouldDelete) {
			[objectParser deleteObject:localEntity];
			if ([self.delegate respondsToSelector:@selector(didDeleteObject:)]) [self.delegate didDeleteObject:localEntity];
		}
		localIndex++;
	}
	
	// Add all these objects
	while (serverIndex<sortedServerObjects.count) {
		
		id serverEntityObject = sortedServerObjects[serverIndex];
		
		BOOL createObject = YES;
		if ([self.delegate respondsToSelector:@selector(shouldCreateObjectForServerObject:)] && ![self.delegate shouldCreateObjectForServerObject:serverEntityObject]) createObject = NO;
		
		if (createObject) {
			id entity = [objectParser newObjectFromServerObject:serverEntityObject];
			if ([self.delegate respondsToSelector:@selector(didCreateObject:)]) [self.delegate didCreateObject:entity];
		
			BOOL result = [objectParser updateLocalObject:entity withServerObject:serverEntityObject error:&error];
			if (!result) {
				if ([self.delegate respondsToSelector:@selector(didFailToParseObject:withServerObject:)]) [self.delegate didFailToParseObject:entity withServerObject:serverEntityObject];
				entity = nil;
				DDLogError(@"Error updating object: %@",error);
			}
			else {
				if ([self.delegate respondsToSelector:@selector(didParseObject:withServerObject:)]) [self.delegate didParseObject:entity withServerObject:serverEntityObject];
				[results addObject:entity];
			}
		}

		serverIndex++;
	}
	
	return results;
}

@end
