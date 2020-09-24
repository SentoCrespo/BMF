//
//  UITableViewCell+BMF.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 22/08/14.
//
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (BMF)

/// Shows an activity indicator in the accessory view
- (void) BMF_showLoadingWithStyle: (UIActivityIndicatorViewStyle) style;

/// Removes the accessory view
- (void) BMF_hideLoading;

@end
