//
//  BMFDefaultFactory.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 04/02/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFDefaultFactory.h"

/// Load Tasks

#import "BMFOperationsTask.h"
#import "BMFLoaderOperation.h"
#import "BMFWriterOperation.h"
#import "BMFAFURLSessionLoader.h"
#import "BMFFileLoader.h"
#import "BMFFileWriter.h"

#import "BMFAFDownloadTaskLoader.h"

/// Serializers
#import "BMFSerializerOperation.h"
#import "BMFJSONSerializer.h"
#import "BMFImageSerializer.h"

#import "BMFDataStoreFactory.h"

#import "BMFParserOperation.h"

#import "BMFUtils.h"

#import "BMFAFNetworkingDataConnectionChecker.h"

static NSArray *networkFactories = nil;
static NSArray *dataStoreFactories = nil;

@implementation BMFDefaultFactory

+ (void) initialize {
	dataStoreFactories = [BMFDataStoreFactory availableFactories];
}

- (NSUserDefaults *) userDefaults {
	return [NSUserDefaults standardUserDefaults];
}

#pragma mark Network

- (id<BMFDataConnectionCheckerProtocol>) dataConnectionChecker {
	return [BMFAFNetworkingDataConnectionChecker new];
}

- (id) loaderWithUrlString:(NSString *) urlString parameters:(NSDictionary *) parameters sender:(id) sender {
	return [self loaderWithUrlString:urlString parameters:parameters method:BMFHTTPMethodGET sender:sender];
}

- (id) loaderWithUrlString:(NSString *) urlString parameters:(NSDictionary *) parameters method:(BMFHTTPMethod)method sender:(id) sender {
	BMFAssertReturnNil(urlString);
	
	BMFAFURLSessionLoader *loader = [BMFAFURLSessionLoader new];
	loader.method = [BMFUtils stringForHTTPMethod:method];
	
	loader.url = [urlString BMF_url];
	BMFAssertReturnNil(loader.url);
	
	loader.parameters = parameters;
	
	return loader;
}

- (id) loaderOperationWithUrlString:(NSString *) urlString parameters:(NSDictionary *) parameters sender:(id) sender {
	return [self loaderOperationWithUrlString:urlString parameters:parameters method:BMFHTTPMethodGET sender:sender];
}

- (id) loaderOperationWithUrlString:(NSString *) urlString parameters:(NSDictionary *) parameters method:(BMFHTTPMethod)method sender:(id)sender {
	BMFAssertReturnNil(urlString);
	
	return [[BMFLoaderOperation alloc] initWithLoader:[self loaderWithUrlString:urlString parameters:parameters method:method sender:sender]];
}

- (id) fileLoaderWithUrl:(NSURL *) fileURL {
	BMFAssertReturnNil(fileURL);
	
	BMFFileLoader *loader = [BMFFileLoader new];
	loader.fileUrl = fileURL;
	return loader;
}

- (id) fileWriterWithUrl:(NSURL *) fileURL {
	BMFAssertReturnNil(fileURL);
	
	BMFFileWriter *writer = [BMFFileWriter new];
	writer.fileUrl = fileURL;
	return writer;
}

- (id) fileLoaderOperationWithUrl:(NSURL *) fileURL sender:(id) sender {
	BMFAssertReturnNil(fileURL);
	return [[BMFLoaderOperation alloc] initWithLoader:[self fileLoaderWithUrl:fileURL]];
}

- (id) fileWriterOperationWithUrl:(NSURL *) fileURL sender:(id) sender {
	BMFAssertReturnNil(fileURL);
	return [[BMFWriterOperation alloc] initWithWriter:[self fileWriterWithUrl:fileURL]];
}

- (id<BMFTaskProtocol>) dataLoadTask:(NSString *) urlString parameters:(NSDictionary *) parameters sender:(id) sender {
	BMFAssertReturnNil(urlString.length>0);
	
	BMFOperation *loadOperation = [self loaderOperationWithUrlString:urlString parameters:parameters sender:sender];
	
	id<BMFTaskProtocol> task = [[BMFOperationsTask alloc] initWithOperations:@[ loadOperation ]];
	return task;
}

- (id<BMFTaskProtocol>) imageLoadTask:(NSString *) urlString parameters:(NSDictionary *) parameters sender:(id) sender {
	BMFAssertReturnNil(urlString.length>0);
	
	BMFOperation *loadOperation = [self loaderOperationWithUrlString:urlString parameters:parameters sender:sender];
	
	BMFOperation *serializeOperation = [self imageSerializerOperation:sender];
	
	return [[BMFOperationsTask alloc] initWithOperations:@[ loadOperation, serializeOperation ]];
}

- (id<BMFTaskProtocol>) jsonLoadTask:(NSString *) urlString parameters:(NSDictionary *) parameters sender:(id) sender {
	BMFAssertReturnNil(urlString.length>0);
	
	BMFOperation *loadOperation = [self loaderOperationWithUrlString:urlString parameters:parameters sender:sender];
	BMFOperation *jsonOperation = [self jsonSerializerOperation:self];
	
	return [[BMFOperationsTask alloc] initWithOperations:@[ loadOperation, jsonOperation ]];
}

- (id<BMFTaskProtocol>) jsonLoadTask:(NSString *) urlString parameters:(NSDictionary *) parameters parser:(id<BMFParserProtocol>)parser sender:(id) sender {
	BMFAssertReturnNil(urlString.length>0);
	BMFAssertReturnNil(parser);
	
	BMFOperation *loadOperation = [self loaderOperationWithUrlString:urlString parameters:parameters sender:sender];
	BMFOperation *jsonOperation = [self jsonSerializerOperation:self];
	BMFOperation *parserOperation = [[BMFParserOperation alloc] initWithParser:parser];
	
	return [[BMFOperationsTask alloc] initWithOperations:@[ loadOperation, jsonOperation, parserOperation ]];
}

- (id<BMFTaskProtocol>) downloadFileTask:(NSString *) urlString parameters:(NSDictionary *) parameters destinationUrl:(NSURL *) destinationUrl sender:(id) sender {
	BMFAssertReturnNil(urlString.length>0);
	BMFAssertReturnNil(destinationUrl);

	BMFAFDownloadTaskLoader *downloadLoader = [[BMFAFDownloadTaskLoader alloc] init];
	downloadLoader.url = [NSURL URLWithString:urlString];
	downloadLoader.localUrl = destinationUrl;
	BMFLoaderOperation *loadOperation = [[BMFLoaderOperation alloc] initWithLoader:downloadLoader];
	
//	BMFOperation *loadOperation = [self loaderOperationWithUrlString:urlString parameters:parameters sender:sender];
//	BMFOperation *writeOperation = [self fileWriterOperationWithUrl:destinationUrl sender:self];
	
	return [[BMFOperationsTask alloc] initWithOperations:@[ loadOperation ]];
}

- (id<BMFTaskProtocol>) notifyErrorTask:(NSString *) urlString text:(NSString *) text sender:(id) sender {
	BMFAssertReturnNil(urlString.length>0);
	BMFAssertReturnNil(text.length>0);
	
	NSDictionary *slackPayload = @{	@"fallback" : text,
									@"text" : text,
									@"color": @"danger",
									@"icon_emoji": @":shit:",
									@"fields" : @[
											@{
												@"title" : @"Device language",
												@"value" : [NSString BMF_nonNilString:[BMFUtils currentLangCode]],
												@"short": @YES
											},
											@{
												@"title" : @"App used language",
												@"value" : [NSString BMF_nonNilString:[BMFUtils currentUsedLangCode]],
												@"short": @YES
											},
											@{
												@"title" : @"Device model",
												@"value" : [NSString BMF_nonNilString:[BMFDevice currentLocalizedDeviceModel]],
												@"short": @YES
											},
											@{
												@"title" : @"OS Version",
												@"value" : [NSString BMF_nonNilString:[BMFUtils osVersion]],
												@"short": @YES
											},
											@{
												@"title" : @"App version",
												@"value" : [NSString BMF_nonNilString:[BMFUtils appVersion]],
												@"short": @YES
											},
											@{
												@"title" : @"App build",
												@"value" : [NSString BMF_nonNilString:[BMFUtils appBuild]],
												@"short": @YES
											},
											@{
												@"title" : @"Device Orientation",
												@"value" : [NSString BMF_nonNilString:[BMFUtils deviceOrientation]],
												@"short": @YES
											}
										]
									};
	NSError *error = nil;
	NSData *dataPayload = [NSJSONSerialization dataWithJSONObject:slackPayload options:0 error:&error];
	if (!dataPayload) {
		DDLogError(@"Error creating payload: %@",error);
		return nil;
	}
	NSString *stringPayload = [[NSString alloc] initWithData:dataPayload encoding:NSUTF8StringEncoding];
	
	BMFOperation *loadOperation = [self loaderOperationWithUrlString:urlString parameters:@{ @"payload" : stringPayload } method:BMFHTTPMethodPOST sender:sender];

	return [[BMFOperationsTask alloc] initWithOperations:@[ loadOperation ]];
}

- (void) notifyError:(NSString *) text {
// The implementation could be something like this:
//	NSString *urlString = @"https://slack.com/services/hooks/incoming-webhook?token=XXXXXXXXX";
//	id<BMFTaskProtocol> task = [self notifyErrorTask:urlString text:text sender:self];
//	[task start:^(id result, NSError *error) {
//		if (error) {
//			DDLogError(@"Error notifying error: %@",error);
//		}
//	}];
	BMFAbstractMethod();
}

#pragma mark Serializers
- (id<BMFSerializerProtocol>) jsonSerializer:(id)sender {
	return [BMFJSONSerializer new];
}

- (id<BMFSerializerProtocol>) imageSerializer:(id)sender{
	return [BMFImageSerializer new];
}

- (BMFOperation *) jsonSerializerOperation:(id)sender {
	return [[BMFSerializerOperation alloc] initWithSerializer:[self jsonSerializer:(id)sender]];
}

- (BMFOperation *) imageSerializerOperation:(id)sender {
	return [[BMFSerializerOperation alloc] initWithSerializer:[self imageSerializer:(id)sender]];
}

- (BMFOperation *) serializerOperationWithSerializer:(id<BMFSerializerProtocol>)serializer sender:(id)sender {
	return [[BMFSerializerOperation alloc] initWithSerializer:serializer];
}


#pragma mark Data Stores

- (id<BMFDataReadProtocol>) dataStoreWithParameter:(id) input sender:(id) sender {
	BMFAssertReturnNil(input);
	
	for (id<BMFDataStoresFactoryProtocol> factory in dataStoreFactories) {
		id object = [factory dataStoreWithParameter:input sender:sender];
		if (object) return object;
	}
	
	return nil;
}

- (id<BMFDataReadProtocol>) dataStoreWithParameters:(NSArray *) parameters sender:(id) sender {
	BMFAssertReturnNil([parameters isKindOfClass:[NSArray class]]);
	
	if (parameters.count==1) return [self dataStoreWithParameter:parameters.firstObject sender:sender];
	
	for (id<BMFDataStoresFactoryProtocol> factory in dataStoreFactories) {
		id object = [factory dataStoreWithParameters:parameters sender:sender];
		if (object) return object;
	}
	
	return nil;
}

#pragma mark Data Sources

- (id<BMFDataReadProtocol>) dataSourceForView:(id)view dataStore:(id<BMFDataReadProtocol>)store cellClassOrNib:(id)classOrNib sender:(id)sender {
	BMFAbstractMethod();
	return nil;
}

- (id<BMFUserMessagesPresenterProtocol>) defaultUserMessagesPresenter {
	return nil;
}

@end
