//
//  BMFButtonCenterImageAspect.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/06/14.
//
//

#import "BMFButtonCenterImageAspect.h"

#import "BMF.h"

@implementation BMFButtonCenterImageAspect

- (void) setObject:(id)object {
	BMFAssertReturn([object isKindOfClass:[UIButton class]]);
	
	[super setObject:object];
}


- (CGRect)contentRectForBounds:(CGRect)bounds {

	UIButton *button = (UIButton *)self.object;
	
	UIImage *image = nil;
	
	if (_mode==BMFButtonCenterImageAspectModeBackgroundImage) image = [button backgroundImageForState:button.state];
	else image = [button imageForState:button.state];
	
	if (image) {
		CGFloat x = (int)((button.bounds.size.width-image.size.width)/2);
		CGFloat y = (int)((button.bounds.size.height-image.size.height)/2);
		return CGRectMake(x, y, image.size.width, image.size.height);
	}
	else return [button contentRectForBounds:bounds];
}

@end
