//
//  BMFIXFont+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/06/14.
//
//

#import "BMFIXFont+BMF.h"

@implementation BMFIXFont (BMF)

- (CTFontRef) BMF_ctFont {
	return CTFontCreateWithName((CFStringRef)self.fontDescriptor.postscriptName, self.pointSize, NULL);
}

- (BMFIXFont *) BMF_boldFont {
#if TARGET_OS_IPHONE
	return [BMFIXFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:self.pointSize];
#else 
	return [BMFIXFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:NSFontBoldTrait] size:self.pointSize];
#endif
}

- (BMFIXFont *) BMF_italicFont {
#if TARGET_OS_IPHONE
	return [BMFIXFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:self.pointSize];
#else
	return [BMFIXFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:NSFontItalicTrait] size:self.pointSize];
#endif
}

- (BMFIXFont *) BMF_regularFont {
	return [BMFIXFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:0] size:self.pointSize];
}

@end
