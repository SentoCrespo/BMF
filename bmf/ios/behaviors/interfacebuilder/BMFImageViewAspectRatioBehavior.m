//
//  BMFImageViewAspectRatioBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/9/15.
//
//

#import "BMFImageViewAspectRatioBehavior.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BMFImageViewAspectRatioBehavior()

@property (nonatomic) NSLayoutConstraint *constraint;

@end

@implementation BMFImageViewAspectRatioBehavior

- (void) viewDidLoad {
	@weakify(self);
	[[RACObserve(self, imageView.image) filter:^BOOL(id value) {
		return self.enabled;
	}] subscribeNext:^(UIImage *image) {
		@strongify(self);
		[self.imageView setNeedsUpdateConstraints];
	}];
}

- (void) updateViewConstraints {
	[self.imageView removeConstraint:self.constraint];
	self.constraint = nil;
	
	if (self.imageView.image.size.width>0) {
		self.constraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeWidth multiplier:self.imageView.image.size.height/self.imageView.image.size.width constant:0];
		
		if (self.priority>0) self.constraint.priority = self.priority;
		[self.imageView addConstraint:self.constraint];
	}
}

@end
