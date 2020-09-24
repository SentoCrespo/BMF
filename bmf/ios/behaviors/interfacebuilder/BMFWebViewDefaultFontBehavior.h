//
//  BMFContentSizeConstraintBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/3/15.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFWebViewDefaultFontBehavior : BMFViewControllerBehavior

/// This view can be a scroll view, a web view, a table view or a collection view
@property (nonatomic, weak) IBOutlet UIWebView *view;

@property (nonatomic, copy) IBInspectable NSString *fontFamily;
@property (nonatomic) IBInspectable NSInteger fontSize;

@end
