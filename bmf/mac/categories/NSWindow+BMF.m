//
//  NSWindow+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/3/15.
//
//

#import "NSWindow+BMF.h"

@implementation NSWindow (BMF)

- (NSRect) BMF_bounds {
	return NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
