//
//  BMFCoreDataObjectParser.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/05/14.
//
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#import "BMFObjectParserProtocol.h"

@interface BMFCoreDataObjectParser : NSObject <BMFObjectParserProtocol>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, weak) id<BMFObjectParserDelegateProtocol> delegate;

- (instancetype) initWithContext:(NSManagedObjectContext *) context;
- (instancetype) init __attribute__((unavailable("Use initWithContext: instead")));

@end
