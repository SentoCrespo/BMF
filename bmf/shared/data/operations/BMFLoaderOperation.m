//
//  TNLoaderOperation.m
//  DataSources
//
//  Created by José Manuel Sánchez on 13/11/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFLoaderOperation.h"

#import "BMF.h"

@interface BMFLoaderOperation()

@property (strong, nonatomic) id<BMFLoaderProtocol> loader;

@end

@implementation BMFLoaderOperation

- (instancetype) initWithLoader:(id<BMFLoaderProtocol>) loader {
	BMFAssertReturnNil(loader);
//	if (!loader) {
//		[NSException raise:BMFLocalized(@"loader required",nil) format:@""];
//		return nil;
//	}

    self = [super init];
    if (self) {
        self.loader = loader;
		self.progress = nil;
    }
    return self;
}
	
- (id)init {
	[NSException raise:BMFLocalized(@"loader required. Use initWithLoader instead",nil) format:@""];
    return nil;
}

- (BMFProgress *) progress {
	return self.loader.progress;
}


- (void) performStart {
	[self.loader load:^(id responseObject, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.output = responseObject;
			
			DDLogDebug(@"loader operation finished: %@",self.loader);
			[self finished];
		});
	}];
}

- (void) performCancel {
	[self.loader cancel];
}

@end
