//
//  BMFScrollPageChangedBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/1/15.
//
//

#import "BMFScrollPageChangedBehavior.h"

#import "BMF.h"

@implementation BMFScrollPageChangedBehavior

- (instancetype) initWithView:(UIScrollView *)scrollView actionBlock:(BMFPageIndexBlock) pageChangedBlock {
	BMFAssertReturnNil(pageChangedBlock);
	
	self = [super initWithView:scrollView];
	if (self) {
		_pageChangedBlock = [pageChangedBlock copy];
	}
	return self;
}

- (void) setPageChangedBlock:(BMFPageIndexBlock)pageChangedBlock {
	BMFAssertReturn(pageChangedBlock);
	
	_pageChangedBlock = [pageChangedBlock copy];
}

#pragma mark UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
	NSInteger pageIndex = 0;
	if (scrollView.bounds.size.height==scrollView.contentSize.height) {
		CGFloat pageWidth = scrollView.bounds.size.width;
		pageIndex = scrollView.contentOffset.x/pageWidth;
	}
	else {
		CGFloat pageHeight = scrollView.bounds.size.height;
		pageIndex = scrollView.contentOffset.y/pageHeight;
	}
	
	if (self.pageChangedBlock) self.pageChangedBlock(pageIndex);
}

@end
