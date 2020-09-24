//
//  BMFKeyedArchiverSerializer.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 8/4/15.
//
//

#import <Foundation/Foundation.h>

#import "BMFSerializerProtocol.h"

@interface BMFKeyedArchiverSerializer : NSObject <BMFSerializerProtocol>

@property (nonatomic) BMFProgress *progress;

@end
