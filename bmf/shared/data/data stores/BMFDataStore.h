//
//  BMFDataStore.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/09/14.
//
//

#import "BMFDataRead.h"

#import "BMFDataStoreProtocol.h"

@interface BMFDataStore : BMFDataRead <BMFDataStoreProtocol>

// Template methods
- (void) performStartUpdating;

/// Returns the indexPath of the added item or nil if it wasn't added
- (NSIndexPath *) performAddItem:(id) item;

/// Returns the indexPath of the inserted item or nil if it wasn't inserted. Might not necessarily be equal to the indexPath parameter
- (NSIndexPath *) performInsertItem:(id) item atIndexPath:(NSIndexPath *) indexPath;

/// Returns the indexPath of the removed item or nil if it wasn't added
- (void) performRemoveItem:(id) item;

- (void) performEndUpdating;
- (void) performRemoveAllItems;
- (void) performSetItems:(id) items;

@end
