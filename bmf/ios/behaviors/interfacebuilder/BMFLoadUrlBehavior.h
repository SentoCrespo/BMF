//
//  BMFLoadUrlBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/2/15.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFLoadUrlBehavior : BMFViewControllerBehavior

@property (nonatomic) IBInspectable BOOL loadInternally;

/// Required only if loadInternally is set to YES
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, copy) IBInspectable NSURL *url;

- (IBAction)load:(id)sender;

@end
