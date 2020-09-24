//
//  BMFAspect.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/04/14.
//
//

#import "BMFAspect.h"

#import "BMF.h"

@implementation BMFAspect

- (void) setOwner:(id)owner {
	[owner BMF_addAspect:self];
}

@end
