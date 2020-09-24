//
//  bmfEncodingTests.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "BMF.h"

#import "BMFUtils.h"
#import "NSString+BMF.h"

SharedExamplesBegin(Encoding)

sharedExamplesFor(@"an encoding", ^(NSDictionary *data) {

	id original = data[@"original"];
	id decoded = data[@"decoded"];
	id encoded = data[@"encoded"];
	
	it(@"should have the correct parameters",^{
		expect(decoded).notTo.beNil();
		expect(encoded).notTo.beNil();
	});
		
	it(@"should be able to decode and encode correctly",^{
		expect(original).to.equal(decoded);
	});
});


SharedExamplesEnd

SpecBegin(Encodings)

describe(@"Path strings", ^{
	
	it(@"should encode and decode the same thing in a cycle", ^{
		NSString *original = @"string to encode";
		
		NSString *encoded = [BMFUtils escapePathString:original];
		NSString *decoded = [BMFUtils unescapePathString:encoded];
				
		itShouldBehaveLike(@"an encoding", @{
											 @"original" : original,
											 @"encoded" : encoded,
											 @"decoded" : decoded
											 });
	});
	
});

describe(@"Url strings", ^{
	
	it(@"should encode and decode the same thing in a cycle", ^{
		NSString *original = @"string to encode";
		
		NSString *encoded = [BMFUtils escapeURLString:original];
		NSString *decoded = [BMFUtils unescapeURLString:encoded];
		
		itShouldBehaveLike(@"an encoding", @{
											 @"original" : original,
											 @"encoded" : encoded,
											 @"decoded" : decoded
											 });
	});
	
});


SpecEnd
