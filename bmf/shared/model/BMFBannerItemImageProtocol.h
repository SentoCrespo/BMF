//
//  BMFBannerItemImageProtocol.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/06/14.
//
//

#import "BMFTypes.h"
#import "BMFBannerItemProtocol.h"

@protocol BMFBannerItemImageProtocol <BMFBannerItemProtocol>

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, strong) BMFIXImage *image;
@property (nonatomic, strong) BMFIXImage *placeholderImage;

@end
