//
//  BMFCellConfiguratorProtocol.h
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFViewRegisterProtocol.h"

typedef NS_ENUM(NSUInteger, BMFViewConfiguratorPriority) {
	BMFViewConfiguratorInvalidPriority = -1,
	BMFViewConfiguratorLibraryPriority = 0,
	BMFViewConfiguratorAppPriority = 1
};

@protocol BMFViewConfiguratorProtocol <NSObject>

+ (BOOL) canConfigure:(id) view kind:(NSString *)kind withItem:(id) item inView:(id)containerView;
+ (void) configure:(id) view kind:(NSString *)kind withItem:(id)item inView:(UIView *) containerView atIndexPath:(NSIndexPath *) indexPath controller:(id) controller;

+ (NSInteger) priority; // Priority for choosing this configurator

@optional

+ (CGFloat) estimatedHeightOf:(id) view kind:(NSString *)kind withItem:(id) item inView:(UIView *) containerView atIndexPath:(NSIndexPath *) indexPath;
+ (CGFloat) heightOf:(id) view kind:(NSString *)kind withItem:(id) item inView:(UIView *) containerView atIndexPath:(NSIndexPath *) indexPath;

@end
