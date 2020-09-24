//
//  BMFCellConfigurator.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFSingleViewConfigurator.h"

#import "BMFTypes.h"

@implementation BMFSingleViewConfigurator

+ (Class) viewClass {
	[NSException raise:@"Your subclass must implement viewClass" format:@""];
	return nil;
}

+ (Class) itemClass {
	[NSException raise:@"Your subclass must implement itemClass" format:@""];
	return nil;
}

+ (Class) containerViewClass {
	return nil;
}

+ (BOOL) canConfigure:(id) view kind:(NSString *)kind withItem:(id) item inView:(id)containerView {
	Class allowedContainerClass = [self containerViewClass];
	if (allowedContainerClass && ![containerView isKindOfClass:allowedContainerClass]) return NO;
	
	if ([view isKindOfClass:[self viewClass]] && [item isKindOfClass:[self itemClass]]) return YES;
	return NO;
}

+ (void) configure:(id) view kind:(NSString *)kind withItem:(id) item inView:(UIView *)containerView atIndexPath:(NSIndexPath *)indexPath controller:(id)controller {
	[NSException raise:@"Your subclass must implement configure:with:inView:atIndexPath:" format:@""];
}

+ (NSInteger) priority {
	return BMFViewConfiguratorInvalidPriority;
}

@end
