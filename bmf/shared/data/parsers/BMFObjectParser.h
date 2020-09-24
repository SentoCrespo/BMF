//
//  BMFObjectParser.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 6/11/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFObjectParserProtocol.h"
#import "BMFParseUtils.h"

@interface BMFObjectParser : NSObject <BMFObjectParserProtocol>

@property (nonatomic, strong) BMFParseUtils *parseUtils;

@end
