//
//  BMFImageViewAspectRatioBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/9/15.
//
//

#import "BMFViewControllerBehavior.h"

/// This behavior observes the image of an image view, and sets a constraint to keep the image view aspect ratio the same as it's contained image
@interface BMFImageViewAspectRatioBehavior : BMFViewControllerBehavior

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic) IBInspectable CGFloat priority;

@end
