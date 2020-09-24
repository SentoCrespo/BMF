//
//  TNAFNetworkingLoader.h
//  DataSources
//
//  Created by José Manuel Sánchez on 22/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFLoaderProtocol.h"

@class AFHTTPRequestSerializer, AFHTTPResponseSerializer;

@interface BMFAFURLSessionLoader : NSObject <BMFLoaderProtocol>

@property (nonatomic, strong) NSURLSessionConfiguration *configuration;

@property (nonatomic, readonly) BMFProgress *progress;

@property (nonatomic, strong) NSCache *cache;

@property (nonatomic, strong) NSURL *url;

/// This parameter can be used to know the final online url (if there aren't any redirections this will just be the same as url)
@property (nonatomic, readonly) NSURL *finalUrl;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *userAgent;

@property (nonatomic, strong) NSDictionary *otherHeadersDic;

/// This shouldn't be needed. Use it only when lying (sending something in a different format than the request serializer)
@property (nonatomic, copy) NSString *contentType;

@property (nonatomic, strong) NSSet *acceptableContentTypes;

@property (nonatomic,strong) NSString *httpBody;

@property (atomic, strong) AFHTTPRequestSerializer *requestSerializer;
@property (atomic, strong) AFHTTPResponseSerializer *responseSerializer;

@end
