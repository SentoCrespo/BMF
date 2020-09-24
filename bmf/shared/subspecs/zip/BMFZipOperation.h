//
//  WALD_UnzipOperation.h
//  wald
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/3/15.
//  Copyright (c) 2015 Treenovum. All rights reserved.
//

#import "BMFOperation.h"

@interface BMFZipOperation : BMFOperation

@property (nonatomic) NSArray *localUrls;

/// Optional. If not set it will add a .zip extension to the first of localUrls
@property (nonatomic) NSURL *destinationZipUrl;

@end
