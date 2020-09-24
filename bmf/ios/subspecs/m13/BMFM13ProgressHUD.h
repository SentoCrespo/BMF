//
//  BMFM13ProgressHUD.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 3/2/15.
//
//

#import "BMFProgressUI.h"

@class M13ProgressHUD;

@interface BMFM13ProgressHUD : BMFProgressUI

- (instancetype) initWithHUD:(M13ProgressHUD *) progressHUD size:(CGSize) size;
- (instancetype) init __attribute__((unavailable("Use initWithHUD:size: instead")));

@end
