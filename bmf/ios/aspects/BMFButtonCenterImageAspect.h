//
//  BMFButtonCenterImageAspect.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/06/14.
//
//

#import "BMFAspect.h"

typedef NS_ENUM(NSInteger, BMFButtonCenterImageAspectMode) {
	BMFButtonCenterImageAspectModeImage,
	BMFButtonCenterImageAspectModeBackgroundImage
};


/// Centers the image or the background image of a button in its frame
@interface BMFButtonCenterImageAspect : BMFAspect

/// BMFButtonCenterImageAspectModeImage by default
@property (nonatomic, assign) BMFButtonCenterImageAspectMode mode;

@end
