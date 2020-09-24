//
//  bmfLoaderTests.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

#import "BMF.h"

#import "BMFFileLoader.h"
#import "BMFStringLoader.h"
#import "BMFAFURLSessionLoader.h"

SpecBegin(Loaders)

describe(@"BMFStringLoader", ^{
	it(@"should load a string correctly", ^AsyncBlock {
		NSString *string = @"blah";
		BMFStringLoader *loader = [BMFStringLoader new];
		expect(^{ [loader load:nil]; }).to.raiseAny();
		expect(^{ [loader load:^(NSString *result,NSError *error){ }]; }).to.raiseAny();
		
		loader.string = string;
		[loader load:^(NSData *resultData, NSError *error) {
			expect(error).to.beNil();
			expect([[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding]).to.equal(string);
			done();
		}];
	});
});

describe(@"BMFFileLoader", ^{
		
	/*it(@"should load a resource file correctly", ^AsyncBlock {
		
		NSURL *fileUrl = [[NSBundle bundleForClass:self.class] URLForResource:@"blah" withExtension:@"txt"];
		expect(fileUrl).notTo.beNil();
		expect(fileUrl.absoluteString.length).to.beGreaterThan(0);
		
		BMFFileLoader *loader = [BMFFileLoader new];
		expect(^{ [loader load:nil]; }).to.raiseAny();
		expect(^{ [loader load:^(NSString *result,NSError *error) {  }]; }).to.raiseAny();
		
		loader = [BMFFileLoader new];
		loader.fileUrl = fileUrl;
		[loader load:^(NSData *resultData, NSError *error) {
			NSString *result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
			expect(error).to.beNil();
			expect(result).to.equal(@"blah");

			
			BMFFileLoader *loader = [BMFFileLoader new];
			
			loader.fileUrl = [NSURL URLWithString:@""];
			
			NSData *data = [NSData dataWithContentsOfURL:loader.fileUrl];
			expect(data).to.beNil();
			
			[loader load:^(id result, NSError *error) {
				expect(result).to.beNil();
				expect(error).notTo.beNil();
				done();
			}];
		}];
		
	});*/
});

describe(@"BMFAFURLSessionLoader", ^{
	
	NSString *response = @"Blah";
	
	beforeAll(^{
		[OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
			return YES;
		} withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
			return [OHHTTPStubsResponse responseWithData:[response dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 headers:nil];
		}];
	});
	
	it(@"shoud raise if no url", ^{
		BMFAFURLSessionLoader *loader = [BMFAFURLSessionLoader new];
		expect(loader).notTo.beNil();
		expect(^{ [loader load:nil]; }).to.raiseAny();
		expect(^{ [loader load:^(NSString *result,NSError *error) {  }]; }).to.raiseAny();
	});
	
	it(@"shoud load correctly with method get, no request params and string response", ^AsyncBlock{
		BMFAFURLSessionLoader *loader = [BMFAFURLSessionLoader new];
		loader.url = [NSURL URLWithString:@"http://www.google.com"];
		[loader load:^(NSData *resultData, NSError *error) {
			NSString *result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
			expect(result).to.equal(response);
			expect(error).to.beNil();
			done();
		}];
	});
	
});

SpecEnd
