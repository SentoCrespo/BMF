//
//  BMFDataStoreSelection.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/07/14.
//
//

#import "BMFDataStoreSelection.h"

#import "BMF.h"

@interface BMFDataStoreSelection()

@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;

@end

@implementation BMFDataStoreSelection

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedIndexPaths = [NSMutableArray array];
		_mode = BMFDataStoreSelectionModeMultiple;
    }
    return self;
}

- (void) setSelection:(NSArray *)selection {
	_selectedIndexPaths = [selection mutableCopy];
}

- (NSArray *) selection {
	return [self.selectedIndexPaths copy];
}

- (void) select:(NSIndexPath *) indexPath {
	BMFAssertReturn(indexPath);
	
	if (_mode==BMFDataStoreSelectionModeSingle) {
		[self selectSingle:indexPath];
	}
	else if (_mode==BMFDataStoreSelectionModeSinglePerSection) {
		[self selectSinglePerSection:indexPath];
	}
	else if (_mode==BMFDataStoreSelectionModeMultiple) {
		[self selectMultiple:indexPath];
	}
}

- (void) selectSingle:(NSIndexPath *) indexPath {
	[_selectedIndexPaths removeAllObjects];
	[_selectedIndexPaths addObject:indexPath];
}

- (void) selectSinglePerSection:(NSIndexPath *) indexPath {
	NSMutableArray *indexesToRemove = [NSMutableArray array];
	for (NSIndexPath *selectedIndexPath in _selectedIndexPaths) {
		if (selectedIndexPath.BMF_section==indexPath.BMF_section) [indexesToRemove addObject:selectedIndexPath];
	}
	
	[_selectedIndexPaths removeObjectsInArray:indexesToRemove];
	[_selectedIndexPaths addObject:indexPath];
}

- (void) selectMultiple:(NSIndexPath *) indexPath {
	[_selectedIndexPaths addObject:indexPath];
}


- (void) deselect:(NSIndexPath *) indexPath {
	[_selectedIndexPaths removeObject:indexPath];
}


@end
