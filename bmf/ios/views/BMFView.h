//
//  BMFView.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 13/12/13.
//  Copyright (c) 2013 José Manuel Sánchez. All rights reserved.
//

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface BMFView : UIView

#else

#import <AppKit/AppKit.h>
IB_DESIGNABLE
@interface BMFView : NSView

#endif

- (void) performInit __attribute((objc_requires_super));

@end
