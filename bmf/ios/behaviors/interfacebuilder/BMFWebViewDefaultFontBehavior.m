//
//  BMFContentSizeConstraintBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/3/15.
//
//

#import "BMFWebViewDefaultFontBehavior.h"

#import "BMF.h"

@interface BMFWebViewDefaultFontBehavior() <UIWebViewDelegate>

@end

@implementation BMFWebViewDefaultFontBehavior

- (void) viewDidLoad {
	if (!self.enabled) return;
	BMFAssertReturn(self.view);
	
	if ([self.view isKindOfClass:[UIWebView class]]) {
		[self.object.BMF_proxy makeDelegateOf:self.view withSelector:@selector(setDelegate:)];
	}		
}

#pragma mark UIWebViewDelegate

- (void) webViewDidFinishLoad:(UIWebView *)webView {
	if (!self.enabled) return;
	if (webView==self.view) {
		if (!self.fontFamily) self.fontFamily = @"-apple-system";
		if (self.fontSize==0) self.fontSize = 14;
		
		NSString *scriptString = [NSString stringWithFormat:@"document.body.style.fontFamily = '%@'; document.body.style.fontSize = '%@pt';",self.fontFamily,@(self.fontSize)];
		[webView stringByEvaluatingJavaScriptFromString: scriptString];
	}
}

@end
