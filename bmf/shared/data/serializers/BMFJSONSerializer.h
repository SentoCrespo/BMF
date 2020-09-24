//
//  BMFJSONSerializer.h
//  DataSources
//
//  Created by José Manuel Sánchez on 22/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFSerializerProtocol.h"

@interface BMFJSONSerializer : NSObject <BMFSerializerProtocol>

@property (nonatomic) NSJSONReadingOptions readingOptions;
@property (nonatomic) NSJSONWritingOptions writingOptions;

@property (nonatomic) BMFProgress *progress;

@end
