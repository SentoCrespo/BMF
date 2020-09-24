//
//  BMFDataStore.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/09/14.
//
//

#import "BMFDataStore.h"

@implementation BMFDataStore

#pragma mark BMFDataStoreProtocol

- (void) startUpdating {
	[self performStartUpdating];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataWillChangeNotification object:self];
}
	
- (BOOL) addItem:(id) item {
	NSIndexPath *addedIdexPath = [self performAddItem:item];
	if (!addedIdexPath) return NO;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataInsertedNotification object:self userInfo:@{ @"indexPath" : addedIdexPath }];
	
	return YES;
}
	
- (BOOL) insertItem:(id) item atIndexPath:(NSIndexPath *) indexPath {
	NSIndexPath *insertedIndexPath = [self performInsertItem:item atIndexPath:indexPath];
	if (!insertedIndexPath) return NO;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataInsertedNotification object:self userInfo:@{ @"indexPath" : insertedIndexPath }];

	return YES;
}
	
- (BOOL) removeItem:(id) item {
	NSIndexPath *indexPath = [self indexOfItem:item];
	[self performRemoveItem:item];
	
	if (!indexPath) return NO;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataDeletedNotification object:self userInfo:@{ @"indexPath" : indexPath }];
	
	return YES;
}
	
- (void) endUpdating {
	[self performEndUpdating];
	
	BMFSupressDeprecationWarning(if (self.applyValueBlock) self.applyValueBlock(self););
	if (self.signalBlock) self.signalBlock(self.allItems);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataDidChangeNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataBatchChangeNotification object:self];
}
	
- (void) removeAllItems {
	[self performRemoveAllItems];
	
	[self notifyDataChanged];
}
	
- (void) setItems:(id) items {
	[self performSetItems:items];
	[self notifyDataChanged];
}


#pragma mark Template methods

- (void) performStartUpdating {}	
- (NSIndexPath *) performAddItem:(id) item { BMFAbstractMethod(); return nil; }
- (NSIndexPath *) performInsertItem:(id) item atIndexPath:(NSIndexPath *) indexPath { BMFAbstractMethod(); return nil; }
- (void) performRemoveItem:(id) item { BMFAbstractMethod(); }
- (void) performEndUpdating {}

- (void) performRemoveAllItems { BMFAbstractMethod(); }
- (void) performSetItems:(id) items { BMFAbstractMethod(); }

@end
