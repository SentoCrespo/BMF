//
//  BMFImageSerializer.m
//  DataSources
//
//  Created by José Manuel Sánchez on 28/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFImageSerializer.h"

#import "BMF.h"

@implementation BMFImageSerializer

- (id)init
{
    self = [super init];
    if (self) {
        _scale = 1.0;
		_writeFormat = BMFImageSerializerFormatJPEG;
		_compressionQuality = 0.8;
		_progress = [BMFProgress new];
		_progress.progressMessage = BMFLocalized(@"Serialize Image", nil);
        _progress.estimatedTime = 0.1;
    }
    return self;
}

- (void) cancel {
	[_progress stop:[NSError errorWithDomain:@"com.bmf.UserCancel" code:BMFErrorCancelled userInfo:@{ NSLocalizedDescriptionKey : BMFLocalized(@"Cancelled", nil) }]];
}

- (NSString *) keyForData: (NSData *)data {
	return @"com.bmf.ImageSerializer";
}

- (NSString *) keyForImage: (BMFIXImage *)image {
	return @"com.bmf.ImageSerializer";
}

- (void) parse:(NSData *) data completion:(BMFCompletionBlock)completionBlock {
	[self.progress start:[self keyForData:data]];
	
	BMFIXImage *image = [BMFImage imageWithData:data scale:self.scale];
	
	[self.progress stop:nil];
	
	if (completionBlock) completionBlock(image,nil);
}

- (void) serialize:(id)object completion:(BMFCompletionBlock)completionBlock {
	BMFAssertReturn([object isKindOfClass:[BMFIXImage class]]);
	
	[self.progress start:[self keyForImage:object]];

	BMFImage *image = object;
	
	NSData *data = nil;
	
	if (self.writeFormat==BMFImageSerializerFormatJPEG) {
		data = [BMFImage BMF_jpegRepresentation:image quality:self.compressionQuality];
	}
	else if (self.writeFormat==BMFImageSerializerFormatPNG) {
		data = [BMFImage BMF_pngRepresentation:image];
	}
	
	NSError *error = nil;
	
	if (!data) error = [NSError errorWithDomain:@"com.bmf.DataError" code:BMFErrorData userInfo:@{ NSLocalizedDescriptionKey : BMFLocalized(@"Couldn't read image data", nil) }];
	
	[self.progress stop:error];
	
	completionBlock(data,error);
}

@end
