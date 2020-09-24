//
//  BMFChangeEncodingOperation.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/5/15.
//
//

#import "BMFOperation.h"

/// Accepts a string or data, and returns a data converted to the final encoding
@interface BMFChangeEncodingOperation : BMFOperation

@property (nonatomic) NSStringEncoding initialEncoding;
@property (nonatomic) NSStringEncoding finalEncoding;

@end
