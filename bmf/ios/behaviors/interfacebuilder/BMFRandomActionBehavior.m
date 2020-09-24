//
//  BMFRandomActionBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 4/12/14.
//
//

#import "BMFRandomActionBehavior.h"

#import <BMF/BMF.h>

@implementation BMFRandomActionBehavior

- (IBAction)run:(id)sender {
	NSInteger index = [BMFUtils randomInteger:0 max:self.objects.count];
	SEL selector = NSSelectorFromString(self.actionName);
	id object = self.objects[index];
	BMFSuppressPerformSelectorLeakWarning([object performSelector:selector withObject:sender]);
}

@end
