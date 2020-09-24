//
//  BMFLogOperation.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 08/01/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFOperation.h"

/*
 
 This class logs the output of the previous operation and outputs it again
 
 */

@interface BMFLogOperation : BMFOperation

/// Message to log before the result of the previous operations. nil by default
@property (nonatomic) NSString *beforeMessage;

/// Message to log after the result of the previous operations. nil by default
@property (nonatomic) NSString *afterMessage;

@end
