//
//  TNArrayDataStore.m
//  DataSources
//
//  Created by José Manuel Sánchez on 22/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFArrayDataStore.h"

@interface BMFArrayDataStore()

//@property (nonatomic, strong) NSMutableArray *storedItems;

@end

@implementation BMFArrayDataStore

- (instancetype)init {
	self = [super init];
	if (self) {
		_storedItems = [NSMutableArray array];
	}
	return self;
}

#pragma mark BMFDataStore template methods

/// Returns the indexPath of the added item or nil if it wasn't added
- (NSIndexPath *) performAddItem:(id) item {
	BMFAssertReturnNil(self.storedItems);
	[self.storedItems addObject:item];
	return [NSIndexPath BMF_indexPathForRow:[self.storedItems indexOfObject:item] inSection:0];
}

/// Returns the indexPath of the inserted item or nil if it wasn't inserted. Might not necessarily be equal to the indexPath parameter
- (NSIndexPath *) performInsertItem:(id) item atIndexPath:(NSIndexPath *) indexPath {
	BMFAssertReturnNil(indexPath.BMF_section==0);
	BMFAssertReturnNil(indexPath.BMF_row<self.storedItems.count);
	BMFAssertReturnNil(self.storedItems);

	[self.storedItems insertObject:item atIndex:indexPath.BMF_row];
	return [NSIndexPath BMF_indexPathForRow:[self.storedItems indexOfObject:item] inSection:0];
}

/// Returns the indexPath of the removed item or nil if it wasn't added
- (void) performRemoveItem:(id) item {
	BMFAssertReturn(self.storedItems);

	NSInteger index = [self.storedItems indexOfObject:item];
	if (index==NSNotFound) {
		return;
	}
	
	//	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataWillChangeNotification object:self];
	[self.storedItems removeObjectAtIndex:index];
}

- (void) performRemoveAllItems {
	BMFAssertReturn(self.storedItems);

	[self.storedItems removeAllObjects];
}

- (void) performSetItems:(id) items {
	BMFAssertReturn(!items || [items isKindOfClass:[NSArray class]]);
	
	_storedItems = [NSMutableArray arrayWithArray:items];
}

#pragma mark TNDataReadProtocol

- (NSInteger) numberOfSections {
	return 1;
}

- (NSInteger) numberOfRowsInSection:(NSUInteger) section {
	return [self.storedItems count];
}

- (NSString *) titleForSection:(NSUInteger)section kind:(NSString *)kind {
	if ([kind isEqualToString:BMFViewKindSectionHeader]) return self.sectionHeaderTitle;
	return self.sectionFooterTitle;
}

- (id) itemAt:(NSInteger) section row:(NSInteger) row {
	BMFAssertReturnNil(section==0);
	BMFAssertReturnNil(row>=0);
	BMFAssertReturnNil(row<self.storedItems.count);
	
	return self.storedItems[row];
}

- (id) itemAt:(NSIndexPath *) indexPath {
	return [self itemAt:indexPath.BMF_section row:indexPath.BMF_row];
}

- (NSIndexPath *) indexOfItem:(id) item {
	if (!item) return nil;
	NSUInteger row = [self.allItems indexOfObject:item];
	if (row==NSNotFound) return nil;
	return [NSIndexPath BMF_indexPathForRow:row inSection:0];
}


- (NSArray *) allItems {
	return self.storedItems;
}

- (void) reload { }

- (BOOL) isEmpty {
	return (self.storedItems.count==0);
}

@end
