//
//  UIScrollView+BMF.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "UIScrollView+BMF.h"

#import "BMFAutoLayoutUtils.h"

@implementation UIScrollView (BMF)

- (NSArray *) BMF_addPagedContainerViews:(NSUInteger) numPages axis:(BMFLayoutConstraintAxis) axis class:(id) containerViewClass {
	
	NSMutableArray *containerArray = [NSMutableArray array];
	for (int i=0;i<numPages;i++) {
		id containerView = [containerViewClass new];
		[self addSubview:containerView];
		[containerArray addObject:containerView];
	}
	
	if (axis==BMFLayoutConstraintAxisHorizontal) {
		[BMFAutoLayoutUtils fillVertically:self withViews:containerArray margin:0];
		[BMFAutoLayoutUtils distributeHorizontally:containerArray inParent:self margin:0];
	}
	else {
		[BMFAutoLayoutUtils fillHorizontally:self withViews:containerArray margin:0];
		[BMFAutoLayoutUtils distributeVertically:containerArray inParent:self margin:0];
	}
	
	[BMFAutoLayoutUtils equalWidths:containerArray];
	[BMFAutoLayoutUtils equalWidths:@[ containerArray.firstObject, self ]];
	
	[BMFAutoLayoutUtils equalHeights:containerArray];
	[BMFAutoLayoutUtils equalHeights:@[ containerArray.firstObject, self ]];


	return containerArray;
}

- (CGSize) BMF_numPages {
	return CGSizeMake(self.contentSize.width/self.bounds.size.width, self.contentSize.height/self.bounds.size.height);
}

- (CGPoint) BMF_offsetForPage:(NSUInteger) page {
	CGSize numPages = [self BMF_numPages];
	
	if (numPages.width>1) {
		return CGPointMake(self.bounds.size.width*page,0);
	}
	else {
		return CGPointMake(0,self.bounds.size.height*page);
	}
}

- (NSUInteger) BMF_currentPage {
	CGSize numPages = [self BMF_numPages];
	if (numPages.width>1) {
		return self.contentOffset.x/self.bounds.size.width;
	}
	else {
		return self.contentOffset.y/self.bounds.size.height;
	}
}


@end
