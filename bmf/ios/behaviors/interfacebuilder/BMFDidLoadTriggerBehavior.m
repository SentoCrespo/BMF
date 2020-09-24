//
//  BMFDidLoadTriggerBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 4/2/15.
//
//

#import "BMFDidLoadTriggerBehavior.h"

@implementation BMFDidLoadTriggerBehavior

- (void) viewDidLoad {
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
