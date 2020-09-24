//
//  TNLoaderProtocol.h
//  DataSources
//
//  Created by José Manuel Sánchez on 22/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFProgress.h"
#import "BMFTypes.h"

typedef NS_ENUM(NSUInteger, BMFHTTPMethod) {
    BMFHTTPMethodGET,
    BMFHTTPMethodPOST,
	BMFHTTPMethodPUT,
	BMFHTTPMethodHEAD,
	BMFHTTPMethodPATCH,
	BMFHTTPMethodDELETE
};

@protocol BMFLoaderProtocol <NSObject>

@property (nonatomic, readonly) BMFProgress *progress;

/// Source can be a url, a file url, a string, etc
- (void) load:(BMFCompletionBlock) completionBlock;
- (void) cancel;

@end
