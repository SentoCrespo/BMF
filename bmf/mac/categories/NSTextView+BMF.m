//
//  NSTextView+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 9/3/15.
//
//

#import "NSTextView+BMF.h"

@implementation NSTextView (BMF)

- (CGFloat) BMF_lineHeight {
	if (self.defaultParagraphStyle.lineSpacing>0) return self.defaultParagraphStyle.lineSpacing;
	
	BOOL isEmtpy = NO;
	if (self.string.length==0) {
		isEmtpy = YES;
		self.string = @"A";
	}
	
	NSRect lineRect = [self.layoutManager lineFragmentRectForGlyphAtIndex:0 effectiveRange:nil];
	
	if (isEmtpy) {
		self.string = @"";
	}
	
	return lineRect.size.height;
}

@end
