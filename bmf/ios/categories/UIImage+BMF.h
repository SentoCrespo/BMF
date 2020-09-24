//
//  UIImage+BMF.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/08/14.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (BMF)

- (UIColor *) BMF_averageColor;

/// This takes the image orientation from its metadata and rotates it accordingly. It will fix problems with camera images being converted to jpeg, for example
- (UIImage *) BMF_imageWithFixedOrientation;

@end
