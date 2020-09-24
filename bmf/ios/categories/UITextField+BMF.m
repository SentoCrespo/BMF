//
//  UITextField+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 3/10/14.
//
//

#import "UITextField+BMF.h"

#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/NSObject+RACDescription.h>

@implementation UITextField (BMF)

- (RACSignal *)rac_keyboardReturnSignal {
	@weakify(self);
	return [[[[RACSignal
			   defer:^{
				   @strongify(self);
				   return [RACSignal return:self];
			   }]
			  concat:[self rac_signalForControlEvents:UIControlEventEditingDidEndOnExit]]
			 takeUntil:self.rac_willDeallocSignal]
			setNameWithFormat:@"%@ -rac_keyboardReturnSignal", [self rac_description]];
}

@end
