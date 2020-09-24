//
//  BMFObjectParser.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 6/11/14.
//
//

#import "BMFObjectParser.h"

@implementation BMFObjectParser

- (instancetype)init {
	self = [super init];
	if (self) {
		_parseUtils = [BMFParseUtils new];
	}
	return self;
}

- (id) parseServerObject:(id)serverObject error:(NSError **) error {
	id localObject = [self newObjectFromServerObject:serverObject];
	if (!localObject) return nil;
	if (![self updateLocalObject:localObject withServerObject:serverObject error:error]) {
		if (error) BMFLogErrorC(BMFLogParseContext, @"Error parsing server object: %@ error: %@",serverObject,*error);
		else BMFLogErrorC(BMFLogParseContext, @"Error parsing server object: %@",serverObject);
		return nil;
	}
	
	return localObject;
}

- (id) newObjectFromServerObject:(id) serverObject {
	BMFAbstractMethod();
	return nil;
}

- (BOOL)updateLocalObject:(id) object withServerObject:(id)serverObject error:(NSError **) error {
	BMFAbstractMethod();
	return NO;
}

@end
