//
//  BMFGroupsDataStore.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 04/07/14.
//
//

#import "BMFGroupsDataStore.h"

@implementation BMFGroupsDataStore


- (instancetype) initWithDataStore:(id<BMFDataReadProtocol>) dataStore childrenBlock:(BMFGroupChildrenBlock) childrenBlock {
	BMFAssertReturnNil(childrenBlock);
	
	self = [super initWithDataStore:dataStore];
	if (self) {
		_childrenBlock = [childrenBlock copy];
	}
	return self;
}

- (void) setChildrenBlock:(BMFGroupChildrenBlock)childrenBlock {
	BMFAssertReturn(childrenBlock);
	
	_childrenBlock = childrenBlock;
}

#pragma mark BMFDataReadProtocol

- (NSInteger) numberOfSections {
	return [self.dataStore numberOfSections];
}

- (NSInteger) numberOfRowsInSection:(NSUInteger) section {
	NSInteger count = 0;
	for (int i=0;i<[self.dataStore numberOfRowsInSection:section];i++) {
		id group = [self.dataStore itemAt:(NSInteger)section row:i];
		count++;
		NSArray *children = self.childrenBlock(group);
		count += children.count;
	}
	
	return count;
}

- (NSString *) titleForSection:(NSUInteger) section kind:(NSString *)kind {
	return [self.dataStore titleForSection:section kind:kind];
}

- (id) itemAt:(NSIndexPath *) indexPath {
	
	BMFAssertReturnNil(indexPath.BMF_section<[self numberOfSections]);
	BMFAssertReturnNil(indexPath.BMF_row<[self numberOfRowsInSection:indexPath.BMF_section]);
	
	int groupIndex = 0;
	int row = 0;
	
	while (row<=indexPath.BMF_row) {
		
		id group = [self.dataStore itemAt:indexPath.BMF_section row:groupIndex];
		if (row==indexPath.BMF_row) return group;
		groupIndex++;
		row++;
		NSArray *children = self.childrenBlock(group);
		if ( (row+(int)children.count-1) >= indexPath.BMF_row) {
			return [children objectAtIndex:(NSUInteger)(indexPath.BMF_row-row)];
		}
		else {
			row += (int)children.count;
		}
	}
	
	return nil;
}

- (NSIndexPath *) indexOfItem:(id) item {
	BMFAssertReturnNil(item);
	
	for (int section=0;section<[self.dataStore numberOfSections];section++) {
		for (int row=0;row<[self.dataStore numberOfRowsInSection:section];row++) {
			id storeItem = [self itemAt:section row:row];
			if ([storeItem isEqual:item]) return [NSIndexPath BMF_indexPathForRow:row inSection:section];
		}
	}
	
	return nil;
}

- (NSArray *) allItems {
	NSMutableArray *items = [NSMutableArray array];
	for (id group in [self.dataStore allItems]) {
		[items addObject:group];
		[items addObjectsFromArray:self.childrenBlock(group)];
	}
	
	return items;
}

- (BOOL) isEmpty {
	return [self.dataStore isEmpty];
}

@end
