//
//  BMFParserStrategy.h
//  metaBooksCoreData
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/05/14.
//  Copyright (c) 2014 Treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFObjectParserProtocol.h"

@interface BMFParserStrategy : NSObject

@property (nonatomic, assign) NSUInteger batchSize;
@property (nonatomic, weak) id<BMFObjectParserDelegateProtocol> delegate;

- (NSArray *) parseServerObjects:(NSArray *) serverObjects localObjects:(NSArray *)localObjects objectParser:(id<BMFObjectParserProtocol>) objectParser;
	
@end
