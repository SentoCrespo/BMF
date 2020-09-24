//
//  BMFParserStrategyProtocol.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/07/14.
//
//

#import <Foundation/Foundation.h>

@protocol BMFParserStrategyProtocol <NSObject>

@property (nonatomic, assign) NSUInteger batchSize;

- (NSArray *) parseServerObjects:(NSArray *) serverObjects localObjects:(NSArray *)localObjects objectParser:(id<BMFObjectParserProtocol>) objectParser;

@end
