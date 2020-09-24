//
//  TNFileWriter.h
//  DataSources
//
//  Created by José Manuel Sánchez on 30/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFWriterProtocol.h"

@interface BMFFileWriter : NSObject <BMFWriterProtocol>

/// YES by default. If no, and the path doesn't exists it will fail
@property (nonatomic) BOOL createIntermediateDirectories;

@property (nonatomic) NSDataWritingOptions options;

@property (nonatomic) NSURL *fileUrl;

@end
