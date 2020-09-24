//
//  BMFLoadUrlBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/2/15.
//
//

#import "BMFLoadUrlBehavior.h"
#import "BMF.h"
#import "BMFURLActivity.h"

@implementation BMFLoadUrlBehavior

- (IBAction)load:(id)sender {
	if (!self.enabled) return;
	BMFAssertReturn(self.url);
	BMFAssertReturn(!self.loadInternally || self.webView);
	if (self.loadInternally) {
		[self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
	else {
		BMFURLActivity *urlActivity = [BMFURLActivity new];
		urlActivity.value = self.url;
		[urlActivity run:^(id result, NSError *error) {
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}];
	}
}

@end
