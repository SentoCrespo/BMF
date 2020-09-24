//
//  BMFEnumerateDataSourceAspect.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/06/14.
//
//

#import "BMFEnumerateDataSourceAspect.h"

#import "BMFDataSourceProtocol.h"

#import "BMF.h"

@implementation BMFEnumerateDataSourceAspect

- (instancetype)init {
    self = [super init];
    if (self) {
		_mode = BMFEnumerateDataSourceAspectModeForward;
		_condition = [BMFTrueCondition new];
		_indexPath = [NSIndexPath BMF_indexPathForRow:0 inSection:0];
    }
    return self;
}

- (void) setObject:(id)object {
	BMFAssertReturn([object conformsToProtocol:@protocol(BMFDataSourceProtocol)]);
	
	[super setObject:object];
}

- (void) action:(id) input completion:(BMFCompletionBlock) completion {
	
	id<BMFDataSourceProtocol> dataSource = self.object;
	id<BMFDataReadProtocol> store = dataSource.dataStore;
	
	if ([store numberOfSections]==0 || [store allItems].count==0) {
		if (completion) completion(nil,[NSError errorWithDomain:@"Data Source aspect" code:BMFErrorData userInfo:@{ NSLocalizedDescriptionKey : BMFLocalized(@"No data in store",nil) }]);
		return;
	}
	
	if ([_condition evaluate]) {
		if (_mode==BMFEnumerateDataSourceAspectModeForward) {
			[self p_enumerateForward:store];
		}
		else {
			[self p_enumerateBackward:store];
		}
	}
		
	if (completion) completion(_indexPath,nil);
}

- (BOOL) p_row:(NSInteger)row section:(NSInteger)section insideStore:(id<BMFDataReadProtocol>) store {
	return ( row>=0 && section>=0 && [store numberOfSections]>section && [store numberOfRowsInSection:section]>row );
}


- (void) p_enumerateForward:(id<BMFDataReadProtocol>) store {
	NSInteger row = _indexPath.BMF_row;
	NSInteger section = _indexPath.BMF_section;

	row++;
	if (![self p_row:row section:section insideStore:store]) {
		section++;
		row = 0;
		if ([store numberOfSections]<=section) section = 0;
		
		/// This should never happen
		BMFAssertReturn([self p_row:row section:section insideStore:store]);
	}
	

	_indexPath = [NSIndexPath BMF_indexPathForRow:row inSection:section];
}


- (void) p_enumerateBackward:(id<BMFDataReadProtocol>) store {
	NSInteger row = _indexPath.BMF_row;
	NSInteger section = _indexPath.BMF_section;
	
	row--;
	if (row<0) {
		section--;
		if (section<0) section = [store numberOfSections]-1;

		row = [store numberOfRowsInSection:section]-1;
		
		/// This should never happen
		BMFAssertReturn([self p_row:row section:section insideStore:store]);
	}
	
	_indexPath = [NSIndexPath BMF_indexPathForRow:row inSection:section];
}

@end
