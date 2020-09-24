//
//  BannerImage.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/07/14.
//
//

#import "BMFBannerImage.h"

@implementation BMFBannerImage

- (instancetype) initWithUrlString:(NSString *)urlString {
	self = [super init];
    if (self) {
        _urlString = urlString;
    }
    return self;
}

- (instancetype) initWithImage:(BMFIXImage *) image {
	self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (CGFloat) proportion {
	CGSize size = self.image.size;
	if (size.height>0) return size.width/size.height;
	return 1;
}

@end
