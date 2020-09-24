//
//  BannerImage.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/07/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"
#import "BMFBannerItemImageProtocol.h"

@interface BMFBannerImage : NSObject <BMFBannerItemImageProtocol>

@property (nonatomic, strong) BMFIXImage *image;
@property (nonatomic, strong) BMFIXImage *placeholderImage;

@property (nonatomic, copy) NSString *urlString;

- (instancetype) initWithUrlString:(NSString *)urlString;
- (instancetype) initWithImage:(BMFIXImage *) image;

- (instancetype) init __attribute__((unavailable("Use initWithUrlString: instead")));

@end
