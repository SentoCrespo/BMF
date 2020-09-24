//
//  BMFScrollViewZooomBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 3/3/15.
//
//

#import "BMFScrollViewZoomBehavior.h"

#import "BMF.h"

@implementation BMFScrollViewZoomBehavior

- (void) viewDidLoad {
	BMFAssertReturn(self.scrollView.maximumZoomScale!=self.scrollView.minimumZoomScale);
}

- (void) setScrollView:(UIScrollView *)scrollView {
	[self.object.BMF_proxy makeDelegateOf:scrollView withSelector:@selector(setDelegate:)];
	
	_scrollView = scrollView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	if (!self.enabled) return nil;
	return self.zoomedView;
}

@end
