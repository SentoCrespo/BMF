//
//  BMFDynamicTypeBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/2/15.
//
//

#import "BMFDynamicTypeBehavior.h"

#import "BMF.h"
#import "BMFObserverBehavior.h"

@interface BMFDynamicTypeBehavior()

@property (nonatomic) BMFObserverBehavior *observerBehavior;

@end

@implementation BMFDynamicTypeBehavior

- (void) viewDidLoad {
	if (!self.enabled) return;
	
	[self p_changeFonts];
	self.observerBehavior = [[BMFObserverBehavior alloc] initWithName:UIContentSizeCategoryDidChangeNotification block:^(id sender) {
		[self p_changeFonts];
	}];
	[self.object addBehavior:self.observerBehavior];
}

- (NSString *) fontStyleConstant {
	if (self.fontStyle.length==0) return UIFontTextStyleBody;
	
	NSString *lowercase = [self.fontStyle lowercaseString];
	
	if ([lowercase isEqualToString:@"body"]) return UIFontTextStyleBody;
	else if ([lowercase isEqualToString:@"headline"]) return UIFontTextStyleHeadline;
	else if ([lowercase isEqualToString:@"subheadline"]) return UIFontTextStyleSubheadline;
	else if ([lowercase isEqualToString:@"footnote"]) return UIFontTextStyleFootnote;
	else if ([lowercase isEqualToString:@"caption1"]) return UIFontTextStyleCaption1;
	else if ([lowercase isEqualToString:@"caption2"]) return UIFontTextStyleCaption2;

	BMFThrowException(Unknown font style);
	return nil;
}

- (void) p_changeFonts {
	UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:[self fontStyleConstant]];
	CGFloat pointSize = fontDescriptor.pointSize+self.pointSizeIncrement;
	UIFont *font = nil;
	if (self.fontFamily.length>0) {
		font = [UIFont fontWithName:self.fontFamily size:pointSize];
	}
	else {
		font = [UIFont fontWithDescriptor:fontDescriptor size:pointSize];
	}
	
	if (self.forceBold) {
		font = [font BMF_boldFont];
	}
	
	if (self.forceItalic) {
		font = [font BMF_italicFont];
	}
	
	for (UIView *view in self.views) {
		BMFAssertReturn([view respondsToSelector:@selector(setFont:)]);
		[(id)view setFont:font];
	}
}

@end
