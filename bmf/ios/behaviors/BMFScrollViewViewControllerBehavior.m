//
//  BMFScrollViewViewControllerBehavior.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFScrollViewViewControllerBehavior.h"

#import "BMFTypes.h"

@implementation BMFScrollViewViewControllerBehavior

- (instancetype) initWithView:(UIScrollView *)scrollView {
	BMFAssertReturnNil(scrollView);
	
    self = [super init];
    if (self) {
		[self.object.BMF_proxy makeDelegateOf:scrollView withSelector:@selector(setDelegate:)];
		_scrollView = scrollView;
	}
    return self;
}

- (void) setScrollView:(UIScrollView *)scrollView {
	BMFAssertReturn(scrollView);
	
	[self.object.BMF_proxy makeDelegateOf:scrollView withSelector:@selector(setDelegate:)];
	
	_scrollView = scrollView;
}

@end
