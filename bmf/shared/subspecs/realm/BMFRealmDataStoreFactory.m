//
//  BMFRealmDataStoreFactory.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/09/14.
//
//

#import "BMFRealmDataStoreFactory.h"

#import <Realm/Realm.h>

#import "BMFRLMArrayDataStore.h"
#import "BMFRealmDataStoreFactory.h"

@implementation BMFRealmDataStoreFactory

+ (void)load {
	[self register];
}

- (id<BMFDataReadProtocol>) dataStoreWithParameter:(id) input sender:(id) sender {
	if ([input isKindOfClass:[RLMArray class]]) {
		return [self arrayDataStore:input sender:sender];
	}
	//else if ([input isKindOfClass:BMFRLMRealmQueryBlock
	
	return nil;
}

- (id<BMFDataReadProtocol>) arrayDataStore:(RLMArray *) array sender:(id) sender {
	BMFRLMArrayDataStore *store = [BMFRLMArrayDataStore new];
	store.items = array;
	return store;
}

@end
