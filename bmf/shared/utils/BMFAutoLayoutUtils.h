//
//  TRNAutoLayoutUtils.h
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 17/12/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"

@interface BMFAutoLayoutUtils : NSObject

+ (NSArray *) fill:(BMFIXView *)parent with:(BMFIXView *) view margin:(CGFloat) margin;
+ (NSArray *) fill:(BMFIXView *)parent with:(BMFIXView *) view margin:(CGFloat) margin priority:(BMFLayoutPriority) priority;
+ (NSArray *) fillHorizontally:(BMFIXView *)parent withViews:(NSArray *)views margin:(CGFloat) margin;
+ (NSArray *) fillVertically:(BMFIXView *)parent withViews:(NSArray *) views margin:(CGFloat) margin;
+ (NSArray *) fillHorizontally:(BMFIXView *)parent withViews:(NSArray *) views margin:(CGFloat) margin priority:(BMFLayoutPriority) priority;
+ (NSArray *) fillVertically:(BMFIXView *)parent withViews:(NSArray *) views margin:(CGFloat) margin priority:(BMFLayoutPriority) priority;


+ (NSArray *) fill:(BMFIXView *)view parent:(BMFIXView *) parent margin:(CGFloat) margin __deprecated;
+ (NSArray *) fill:(BMFIXView *)view parent:(BMFIXView *) parent margin:(CGFloat) margin priority:(BMFLayoutPriority) priority __deprecated;
+ (NSArray *) fillHorizontally:(NSArray *)views parent:(BMFIXView *) parent margin:(CGFloat) margin __deprecated;
+ (NSArray *) fillVertically:(NSArray *)views parent:(BMFIXView *) parent margin:(CGFloat) margin __deprecated;
+ (NSArray *) fillHorizontally:(NSArray *)views parent:(BMFIXView *) parent margin:(CGFloat) margin priority:(BMFLayoutPriority) priority __deprecated;
+ (NSArray *) fillVertically:(NSArray *)views parent:(BMFIXView *) parent margin:(CGFloat) margin priority:(BMFLayoutPriority) priority __deprecated;

+ (NSArray *) constraint:(NSArray *) views toParent:(BMFIXView *) parent margin:(CGFloat) margin;
+ (NSArray *) constraintHorizontally:(NSArray *) views toParent:(BMFIXView *) parent margin:(CGFloat) margin priority:(BMFLayoutPriority) priority;
+ (NSArray *) constraintVertically:(NSArray *) views toParent:(BMFIXView *) parent margin:(CGFloat) margin priority:(BMFLayoutPriority) priority;

+ (NSArray *) centerView:(BMFIXView *) view inParent:(BMFIXView *)parent;
+ (NSArray *) center:(NSArray *) views inParent:(BMFIXView *)parent margin:(CGFloat) margin;
+ (NSArray *) centerVertically:(NSArray *) views inParent:(BMFIXView *)parent margin:(CGFloat) margin;
+ (NSArray *) centerHorizontally:(NSArray *) views inParent:(BMFIXView *)parent margin:(CGFloat) margin;

+ (NSArray *) distributeHorizontally: (NSArray *)views inParent:(BMFIXView *)parent margin:(CGFloat) margin;
+ (NSArray *) distributeVertically: (NSArray *)views inParent:(BMFIXView *)parent margin:(CGFloat) margin;
+ (NSArray *) distributeHorizontally: (NSArray *)views inParent:(BMFIXView *)parent internalMargin:(CGFloat)internalMargin externalMargin:(CGFloat)externalMargin;
+ (NSArray *) distributeHorizontally: (NSArray *)views inParent:(BMFIXView *)parent internalMargin:(CGFloat)internalMargin externalMargin:(CGFloat)externalMargin priority:(BMFLayoutPriority) priority;
+ (NSArray *) distributeVertically: (NSArray *)views inParent:(BMFIXView *)parent internalMargin:(CGFloat)internalMargin externalMargin:(CGFloat)externalMargin;
+ (NSArray *) distributeVertically: (NSArray *)views inParent:(BMFIXView *)parent internalMargin:(CGFloat)internalMargin externalMargin:(CGFloat)externalMargin priority:(BMFLayoutPriority) priority;


+ (void) sizeEqualContent: (BMFIXView *) view;
+ (void) sizeGreaterEqualContent: (BMFIXView *) view;
+ (void) sizeSmallerEqualContent: (BMFIXView *) view;

+ (NSArray *) sizeEqual: (BMFIXView *) view constant:(CGSize) size;
+ (NSArray *) sizeEqual: (BMFIXView *) view constant:(CGSize) size priority:(BMFLayoutPriority) priority;
+ (NSLayoutConstraint *) widthEqual: (BMFIXView *) view constant:(CGFloat) constant;
+ (NSLayoutConstraint *) widthEqual: (BMFIXView *) view constant:(CGFloat) constant priority:(BMFLayoutPriority) priority;
+ (NSLayoutConstraint *) heightEqual: (BMFIXView *) view constant:(CGFloat) constant;
+ (NSLayoutConstraint *) heightEqual: (BMFIXView *) view constant:(CGFloat) constant priority:(BMFLayoutPriority) priority;

+ (NSArray *) sizeLessOrEqual: (BMFIXView *) view constant:(CGSize) size;
+ (NSArray *) sizeLessOrEqual: (BMFIXView *) view constant:(CGSize) size priority:(BMFLayoutPriority) priority;
+ (NSArray *) widthLessOrEqual: (BMFIXView *) view constant:(CGFloat) constant;
+ (NSArray *) widthLessOrEqual: (BMFIXView *) view constant:(CGFloat) constant priority:(BMFLayoutPriority) priority;
+ (NSArray *) heightLessOrEqual: (BMFIXView *) view constant:(CGFloat) constant;
+ (NSArray *) heightLessOrEqual: (BMFIXView *) view constant:(CGFloat) constant priority:(BMFLayoutPriority) priority;

+ (NSArray *) sizeGreaterOrEqual: (BMFIXView *) view constant:(CGSize) size;
+ (NSArray *) sizeGreaterOrEqual: (BMFIXView *) view constant:(CGSize) size priority:(BMFLayoutPriority) priority;
+ (NSLayoutConstraint *) widthGreaterOrEqual: (BMFIXView *) view constant:(CGFloat) constant;
+ (NSLayoutConstraint *) widthGreaterOrEqual: (BMFIXView *) view constant:(CGFloat) constant priority:(BMFLayoutPriority) priority;
+ (NSLayoutConstraint *) heightGreaterOrEqual: (BMFIXView *) view constant:(CGFloat) constant;
+ (NSLayoutConstraint *) heightGreaterOrEqual: (BMFIXView *) view constant:(CGFloat) constant priority:(BMFLayoutPriority) priority;

+ (NSLayoutConstraint *) makeSquare:(BMFIXView *) view;
+ (NSLayoutConstraint *) proportionEqual:(BMFIXView *) view multiplier:(CGFloat) multiplier;
+ (NSLayoutConstraint *) proportionEqual:(BMFIXView *) view multiplier:(CGFloat) multiplier priority:(BMFLayoutPriority) priority;
+ (NSLayoutConstraint *) proportionEqual:(BMFIXView *) view multiplier:(CGFloat) multiplier constant:(CGFloat) constant priority:(BMFLayoutPriority) priority;

+ (NSArray *) equalLayouts:(NSArray *) views;
+ (NSArray *) equalLayouts:(NSArray *) views inParent:(BMFIXView *)parent;
+ (NSArray *) equalWidths: (NSArray *)views;
+ (NSArray *) equalHeights: (NSArray *)views;
+ (NSArray *) equalWidths: (NSArray *)views inParent:(BMFIXView *)parent;
+ (NSArray *) equalHeights: (NSArray *)views inParent:(BMFIXView *)parent;
+ (NSArray *) equalWidths: (NSArray *)views inParent:(BMFIXView *)parent priority:(BMFLayoutPriority)priority;
+ (NSArray *) equalHeights: (NSArray *)views inParent:(BMFIXView *)parent priority:(BMFLayoutPriority)priority;

+ (NSArray *) equalTops: (NSArray *)views;
+ (NSArray *) equalTops: (NSArray *)views inParent:(BMFIXView *)parent;
+ (NSArray *) equalBottoms: (NSArray *)views;
+ (NSArray *) equalBottoms: (NSArray *)views inParent:(BMFIXView *)parent;
+ (NSArray *) equalLefts: (NSArray *)views;
+ (NSArray *) equalLefts: (NSArray *)views inParent:(BMFIXView *)parent;
+ (NSArray *) equalRights: (NSArray *)views;
+ (NSArray *) equalRights: (NSArray *)views inParent:(BMFIXView *)parent;
+ (NSArray *) equalCenters: (NSArray *)views;
+ (NSArray *) equalCenters: (NSArray *)views inParent:(BMFIXView *)parent;
+ (NSArray *) equalHorizontalCenters: (NSArray *)views;
+ (NSArray *) equalHorizontalCenters: (NSArray *)views inParent:(BMFIXView *)parent;
+ (NSArray *) equalVerticalCenters: (NSArray *)views;
+ (NSArray *) equalVerticalCenters: (NSArray *)views inParent:(BMFIXView *)parent;

+ (NSArray *) equalAttributes: (NSArray *)views parent:(BMFIXView *)parent attribute:(NSLayoutAttribute)attribute margin:(CGFloat)margin priority:(BMFLayoutPriority) priority;

+ (NSLayoutConstraint *) copyConstraint:(NSLayoutConstraint *) constraint;

+ (NSArray *) changeConstraint:(NSLayoutConstraint *) constraint parent:(BMFIXView *) parent priority:(BMFLayoutPriority) priority;

+ (void) setContentCompressionResistance:(BMFIXView *) view priority:(BMFLayoutPriority) priority axis:(BMFLayoutConstraintAxis) axis;
+ (void) setContentHugging:(BMFIXView *) view priority:(BMFLayoutPriority) priority axis:(BMFLayoutConstraintAxis) axis;

@end
