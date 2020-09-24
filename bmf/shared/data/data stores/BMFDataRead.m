//
//  BMFDataRead.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/07/14.
//
//

#import "BMFDataRead.h"

#import "BMFDataStoreSelection.h"

@implementation BMFDataRead

- (instancetype)init
{
    self = [super init];
    if (self) {
		_progress = [BMFProgress new];
    }
    return self;
}

- (void) notifyDataChanged {
	if (self.applyValueBlock) self.applyValueBlock(self);
	if (self.signalBlock) self.signalBlock(self.allItems);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BMFDataBatchChangeNotification object:self];
}

- (void) notifyValueChanged:(id)sender {
	[self notifyDataChanged];
}

- (void) setApplyValueBlock:(BMFActionBlock)applyValueBlock {
	_applyValueBlock = [applyValueBlock copy];
	if (_applyValueBlock) _applyValueBlock(self);
}

#pragma mark BMFDataReadProtocol

- (NSString *) titleForSection:(NSUInteger) section kind:(NSString *)kind {
	return nil;
}

- (id) itemAt:(NSInteger) section row:(NSInteger) row {
	return [self itemAt:[NSIndexPath BMF_indexPathForRow:row inSection:section]];
}

- (NSInteger) numberOfSections {
	BMFAbstractMethod();
	return 0;
}

- (NSInteger) numberOfRowsInSection:(NSUInteger) section {
	BMFAbstractMethod();
	return 0;
}

- (id) itemAt:(NSIndexPath *) indexPath {
	BMFAbstractMethod();
	return nil;
}

- (NSIndexPath *) indexOfItem:(id) item {
	BMFAbstractMethod();
	return nil;
}

- (NSArray *) allItems {
	BMFAbstractMethod();
	return nil;
}

- (BOOL) isEmpty {
	BMFAbstractMethod();
	return YES;
}

- (void) reload {
	BMFAbstractMethod();
}

- (BOOL) indexPathInsideBounds:(NSIndexPath *) indexPath {
	if (indexPath.BMF_section>=[self numberOfSections]) return NO;
	if (indexPath.BMF_row>=[self numberOfRowsInSection:indexPath.BMF_section]) return NO;
	
	return YES;
}

@end
