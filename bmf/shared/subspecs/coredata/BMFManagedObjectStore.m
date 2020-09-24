//
//  BMFManagedObjectDataStore.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 19/05/14.
//
//

#import "BMFManagedObjectStore.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "NSNotification+BMFCoreData.h"

@interface BMFManagedObjectStore()

@property (nonatomic, strong) RACDisposable *subscription;

@end

@implementation BMFManagedObjectStore

- (instancetype)init
{
    self = [super init];
    if (self) {
		@weakify(self);
		[RACObserve(self, value) subscribeNext:^(NSManagedObject *managedObject) {
			@strongify(self);
			if (managedObject) {
				[self.subscription dispose];
				self.subscription = [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:NSManagedObjectContextDidSaveNotification object:nil] filter:^BOOL(NSNotification *note) {
					return managedObject.managedObjectContext!=note.object;
				}] subscribeNext:^(NSNotification *note) {
					BMFNotificationChangeType changeType = [note BMF_changeForObjectID:self.value.objectID];
					if (changeType==BMFNotificationNoChangeType) return;
					else if (changeType==BMFNotificationDeletedChangeType) {
						self.value = nil;
					}
					else {
						[self.value.managedObjectContext refreshObject:self.value mergeChanges:YES];
						if (self.applyValueBlock) self.applyValueBlock(self);
					}
				}];
			}
		}];
    }
    return self;
}

@end
