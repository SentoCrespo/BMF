//
//  TNFRDataStore.m
//  DataSources
//
//  Created by José Manuel Sánchez on 05/11/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFFRCDataStore.h"
#import "BMFDataStoreSelection.h"

#import <MagicalRecord/MagicalRecord.h>

@implementation BMFFRCDataStore

- (instancetype)initWithController:(NSFetchedResultsController *)fr {
	
	BMFAssertReturnNil(fr);
	
    self = [super init];
    if (self) {
        _fr = fr;
		_fr.delegate = self;
    }
    return self;
}

- (NSInteger) numberOfSections {
	if (self.fr.fetchedObjects.count==0) [self reload];
	
	return [self.fr.sections count];
}

- (NSInteger) numberOfRowsInSection:(NSUInteger) section {
	if (self.fr.fetchedObjects.count==0) [self reload];

	id<NSFetchedResultsSectionInfo> info = self.fr.sections[section];
	// This is needed to avoid a bug where merging contexts will ignore the fetchlimit and result in a crash
	NSInteger numObjects = info.numberOfObjects;
	if (numObjects>self.fr.fetchRequest.fetchLimit && self.fr.fetchRequest.fetchLimit>0) {
		numObjects = self.fr.fetchRequest.fetchLimit;
	}

    return numObjects;
}

- (NSString *) titleForSection:(NSUInteger)section kind:(NSString *)kind {
	if ([kind isEqualToString:BMFViewKindSectionHeader]) {
		id<NSFetchedResultsSectionInfo> info = self.fr.sections[section];
		return info.name;
	}
	
	return nil;
}

- (id) itemAt:(NSInteger) section row:(NSInteger) row {
	 return [self.fr objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
}

- (id) itemAt:(NSIndexPath *) indexPath {
	return [self itemAt:indexPath.section row:indexPath.row];
}

- (NSIndexPath *) indexOfItem:(id) item {
	NSUInteger row = [self.allItems indexOfObject:item];
	if (row==NSNotFound) return nil;
	return [NSIndexPath indexPathForRow:row inSection:0];
}

- (NSArray *) allItems {
	if (self.fr.fetchedObjects.count==0) [self reload];

	return self.fr.fetchedObjects;
}

- (BOOL) isEmpty {
	return (self.fr.fetchedObjects.count==0);
}

#pragma mark NSFetchedResultsController

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataWillChangeNotification object:self];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    switch(type) {
        case NSFetchedResultsChangeInsert:
			[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataSectionInsertedNotification object:self userInfo:@{ @"index" : @(sectionIndex) }];
            break;
			
        case NSFetchedResultsChangeDelete:
			[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataSectionDeletedNotification object:self userInfo:@{ @"index" : @(sectionIndex) }];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
			[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataInsertedNotification object:self userInfo:@{ @"indexPath" : newIndexPath }];
            break;
			
        case NSFetchedResultsChangeDelete:
			[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataDeletedNotification object:self userInfo:@{ @"indexPath" : indexPath }];
            break;
			
        case NSFetchedResultsChangeUpdate:
			[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataUpdatedNotification object:self userInfo:@{ @"indexPath" : indexPath }];
			
            break;
			
        case NSFetchedResultsChangeMove:
			[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataDeletedNotification object:self userInfo:@{ @"indexPath" : indexPath }];
			[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataInsertedNotification object:self userInfo:@{ @"indexPath" : newIndexPath }];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataDidChangeNotification object:self];

	[self notifyDataChanged];
}

- (void) reload {
	NSError *error = nil;
	[self.progress start:@"frcdatastore"];
	_loaded = [self.fr performFetch:&error];
	[self.progress stop:error];
}

#pragma mark BMFDataStore

// Template methods
- (void) performStartUpdating { }

/// Returns the indexPath of the added item or nil if it wasn't added
- (NSIndexPath *) performAddItem:(id) item {
	NSManagedObject *object = [NSManagedObject BMF_cast:item];
	BMFAssertReturnNil(object);
	if (!object.managedObjectContext) {
		[self.fr.managedObjectContext insertObject:object];
	}

	return [NSIndexPath BMF_indexPathForRow:NSNotFound inSection:0];
}

/// Returns the indexPath of the inserted item or nil if it wasn't inserted. Might not necessarily be equal to the indexPath parameter
- (NSIndexPath *) performInsertItem:(id) item atIndexPath:(NSIndexPath *) indexPath {
	NSManagedObject *object = [NSManagedObject BMF_cast:item];
	BMFAssertReturnNil(object);

	if (!object.managedObjectContext) {
		[self.fr.managedObjectContext insertObject:object];
	}
	
	return [NSIndexPath BMF_indexPathForRow:NSNotFound inSection:0];
}

/// Returns the indexPath of the removed item or nil if it wasn't added
- (void) performRemoveItem:(id) item {
	BMFAssertReturn([item isKindOfClass:[NSManagedObjectContext class]]);
	[self.fr.managedObjectContext deleteObject:item];
}

- (void) performEndUpdating {
	NSError *error = nil;
	if (![self.fr.managedObjectContext save:&error]) {
		BMFLogError(@"Error saving frc: %@",error);
	}
}

- (void) performRemoveAllItems {
	for (NSManagedObject *object in self.fr.fetchedObjects) {
		[self.fr.managedObjectContext deleteObject:object];
	}
	
	[self performEndUpdating];
}

- (void) performSetItems:(id) items {
	for (id item in items) {
		[self performAddItem:item];
	}
	
	[self performEndUpdating];
}

@end
