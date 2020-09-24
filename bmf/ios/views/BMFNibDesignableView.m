//
//  BMFNibDesignableView.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/11/14.
//
//

#import "BMFNibDesignableView.h"

@implementation BMFNibDesignableView

- (instancetype) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		
	}
	return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		
	}
	return self;
}

- (void) bmf_setupNib {
	UIView *view = [self bmf_loadNib];
	view.frame = self.bounds;
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self addSubview:view];
}

- (NSString *) bmf_nibName {
	return [[[self.class description] componentsSeparatedByString:@"."] lastObject];
}

- (UIView *) bmf_loadNib {
	NSBundle *bundle = [NSBundle bundleForClass:self.class];
	UINib *nib = [UINib nibWithNibName:[self bmf_nibName] bundle:bundle];
	return [[nib instantiateWithOwner:self options:nil] firstObject];
}

@end
