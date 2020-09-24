//
//  BMFDefaultFactory.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 04/02/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFNetworkFactoryProtocol.h"
#import "BMFOperationsFactoryProtocol.h"
#import "BMFDataStoresFactoryProtocol.h"
#import "BMFSerializerProtocol.h"
#import "BMFParserProtocol.h"
#import "BMFLoaderProtocol.h"
#import "BMFMessagePresenterFactoryProtocol.h"
#import "BMFTaskProtocol.h"
#import "BMFDataReadProtocol.h"
#import "BMFDataSourceProtocol.h"
#import "BMFThemeProtocol.h"
#import "BMFDataConnectionCheckerProtocol.h"

//@protocol BMFTaskProtocol;
//@protocol BMFDataReadProtocol;
//@protocol BMFDataSourceProtocol;

@class BMFOperation;
@class BMFSettingsManager;

@interface BMFDefaultFactory : NSObject <BMFNetworkFactoryProtocol, BMFOperationsFactoryProtocol,BMFDataStoresFactoryProtocol, BMFMessagePresenterFactoryProtocol>

- (NSUserDefaults *) userDefaults;

#pragma mark Network

- (id<BMFDataConnectionCheckerProtocol>) dataConnectionChecker;

- (id) loaderWithUrlString:(NSString *) urlString parameters:(NSDictionary *) parameters sender:(id) sender;
- (id) loaderWithUrlString:(NSString *) urlString parameters:(NSDictionary *) parameters method:(BMFHTTPMethod)method sender:(id) sender;
- (id) loaderOperationWithUrlString:(NSString *) urlString parameters:(NSDictionary *) parameters sender:(id) sender;
- (id) loaderOperationWithUrlString:(NSString *) urlString parameters:(NSDictionary *) parameters method:(BMFHTTPMethod)method sender:(id) sender;

- (id) fileLoaderOperationWithUrl:(NSURL *) fileURL sender:(id) sender;
- (id) fileWriterOperationWithUrl:(NSURL *) fileURL sender:(id) sender;

- (id<BMFTaskProtocol>) dataLoadTask:(NSString *) urlString parameters:(NSDictionary *) parameters sender:(id) sender;
- (id<BMFTaskProtocol>) imageLoadTask:(NSString *) urlString parameters:(NSDictionary *) parameters sender:(id) sender;

- (id<BMFTaskProtocol>) jsonLoadTask:(NSString *) urlString parameters:(NSDictionary *) parameters sender:(id) sender;

- (id<BMFTaskProtocol>) jsonLoadTask:(NSString *) urlString parameters:(NSDictionary *) parameters parser:(id<BMFParserProtocol>)parser sender:(id) sender;

/// Task to notify of an error to the developers of the app. This should be used for when a remote config file can't be parsed or important errors that the developer should be aware of. You can subclass this method to customize or change the behavior. Don't use this directly in code, use the notifyError method
- (id<BMFTaskProtocol>) notifyErrorTask:(NSString *) urlString text:(NSString *) text sender:(id) sender;

/// Template method to notify errors to a url. You have to implement this in a factory subclass in order to use it (thows an exception otherwise). 
- (void) notifyError:(NSString *) text;

#pragma mark Operations

- (id<BMFSerializerProtocol>) jsonSerializer:(id)sender;
- (id<BMFSerializerProtocol>) imageSerializer:(id)sender;

- (BMFOperation *) jsonSerializerOperation:(id)sender;
- (BMFOperation *) imageSerializerOperation:(id)sender;

- (BMFOperation *) serializerOperationWithSerializer:(id<BMFSerializerProtocol>)serializer sender:(id)sender;

#pragma mark Data Stores

- (id<BMFDataReadProtocol>) dataStoreWithParameter:(id) input sender:(id) sender;
- (id<BMFDataReadProtocol>) dataStoreWithParameters:(NSArray *) parameters sender:(id) sender;

#pragma mark Data Sources

/// Retrieves a valid data source for this view or nil. The cellClassOrNib is used for tables and collection views, it is ignored for map views
- (id<BMFDataReadProtocol>) dataSourceForView:(id)view dataStore:(id<BMFDataReadProtocol>)store cellClassOrNib:(id)classOrNib sender:(id)sender;

#pragma mark Messages presenter

- (id<BMFUserMessagesPresenterProtocol>) defaultUserMessagesPresenter;


@end
