//
//  WALD_UnzipOperation.h
//  wald
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/3/15.
//  Copyright (c) 2015 Treenovum. All rights reserved.
//

#import "BMFOperation.h"

@interface BMFUnzipOperation : BMFOperation

@property (nonatomic) NSURL *localZipUrl;

/// Optional. If not set the localZipUrl path will be chosen
@property (nonatomic) NSURL *destinationUrl;

@end
