//
//  BMFM13ProgressView.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 27/05/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFProgressUI.h"

@class M13ProgressView;

@interface BMFM13ProgressView : BMFProgressUI

/// Needs a M13ProgressView. This view will be added as a subview
- (instancetype) initWithView:(M13ProgressView *) progressView size:(CGSize) size;
- (instancetype) init __attribute__((unavailable("Use initWithView:size: instead")));


@end
