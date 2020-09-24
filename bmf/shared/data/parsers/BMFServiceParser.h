//
//  BMFServiceParser.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/07/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFParserProtocol.h"
#import "BMFProgress.h"

@interface BMFServiceParser : NSObject <BMFParserProtocol>

@property (nonatomic, strong) BMFProgress *progress;

- (NSString *) parserName;
- (Class) rawObjectClass;
- (id) performParse:(id) rawObject error:(NSError **)error;

@end
