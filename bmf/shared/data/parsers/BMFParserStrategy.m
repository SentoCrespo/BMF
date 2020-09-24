//
//  BMFParserStrategy.m
//  metaBooksCoreData
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/05/14.
//  Copyright (c) 2014 Treenovum. All rights reserved.
//

#import "BMFParserStrategy.h"

#import "BMF.h"

@implementation BMFParserStrategy

- (instancetype) init {
	self = [super init];
	if (self) {
		self.batchSize = 50;
	}
	return self;
}

- (NSArray *) parseServerObjects:(NSArray *)serverObjects localObjects:(NSArray *)localObjects objectParser:(id<BMFObjectParserProtocol>)objectParser {
	BMFAbstractMethod();
	return nil;
}

@end
