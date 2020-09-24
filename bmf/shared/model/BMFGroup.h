//
//  BMFGroup.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFImage.h"

@interface BMFGroup : NSObject

@property (nonatomic, strong) NSString *ident;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) BMFIXImage *image;

@property (nonatomic, strong) BMFGroup *parent;
@property (nonatomic, strong) NSArray *children;

@end
