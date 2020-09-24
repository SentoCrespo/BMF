//
//  BMFPagedScrollViewBehavior.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFPagedScrollViewBehavior.h"

#import "BMFTypes.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation BMFPagedScrollViewBehavior

@dynamic scrollView;

- (void) viewDidLoad {
	if (!self.enabled) return;
	BMFAssertReturn(self.scrollView);
	
	self.scrollView.pagingEnabled = YES;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	[self.object.BMF_proxy makeDelegateOf:self.scrollView withSelector:@selector(setDelegate:)];
	
	@weakify(self);
	[RACObserve(self, scrollView.contentSize) subscribeNext:^(id x) {
		@strongify(self);
		self.pageControl.numberOfPages = self.scrollView.contentSize.width/self.scrollView.frame.size.width;
	}];
	
	[self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
}

#pragma mark PageControl

- (void)changePage {
	if (!self.enabled) return;
	BMFAssertReturn(self.scrollView);
	
	CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!self.enabled) return;
	BMFAssertReturn(self.scrollView);
	if ([sender isEqual:self.scrollView]) {
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		
		self.pageControl.currentPage = page;
	}
}

@end
