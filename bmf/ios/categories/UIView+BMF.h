//
//  UIView+BMF.h
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/01/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BMF)

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

- (void) BMF_removeAllGestureRecognizers;

- (void) BMF_setSubviews:(NSArray *) views;
- (void) BMF_addSubviews:(NSArray *) views;
- (void) BMF_removeAllSubviews;
- (void) BMF_removeAllExcept:(NSArray *) views;

// Removes all constraints stored here and in the parent that affect this view
- (void) BMF_removeAllConstraints;

- (void) BMF_removeAllConstraints:(BOOL) recursive;

/// Removes all the constraints that make a reference to any view in the subviews array
- (void) BMF_RemoveConstraintsWithViews:(NSArray *) subviews;

- (UIView *) BMF_findSuperviewWithClass:(Class) viewClass;

/// In debug mode only it uses the private api to set the autolayout identifier for debugging purposes
- (void) BMF_setAutolayoutIdentifier:(NSString *) identifier;

- (BOOL) BMF_descendsFrom:(UIView *)view;
- (BOOL) BMF_hasDescendant:(UIView *)view;

@end
