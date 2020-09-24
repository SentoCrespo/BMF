//
//  UIWebView+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/3/15.
//
//

#import "UIWebView+BMF.h"

@implementation UIWebView (BMF)

- (void) BMF_makeBackgroundTransparent {
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
	[self stringByEvaluatingJavaScriptFromString:@"document.body.style.backgroundColor = 'transparent';"];
}

@end
