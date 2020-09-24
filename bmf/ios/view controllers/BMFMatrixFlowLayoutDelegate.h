//
//  TRNColumnsLayoutDelegate.h
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 13/03/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import "BMFViewControllerBehavior.h"

#import "BMFDeviceValue.h"

typedef enum : NSUInteger {
	BMFMatrixFlowLayoutDelegateVerticalModeRows,
    BMFMatrixFlowLayoutDelegateVerticalModeFixed,
    BMFMatrixFlowLayoutDelegateVerticalModeAspectRatio
} BMFMatrixFlowLayoutDelegateVerticalMode;

@interface BMFMatrixFlowLayoutDelegate : BMFViewControllerBehavior <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) BMFDeviceValue *numColumns;

@property (nonatomic) IBInspectable NSUInteger defaultNumColumns;
@property (nonatomic) IBInspectable NSUInteger defaultNumRows;

/// Margin to the edges of a section. 10 by default
@property (nonatomic, assign) IBInspectable CGFloat outerMargin;

/// Margin between items. 10 by default
@property (nonatomic, assign) IBInspectable CGFloat innerMargin;

/// Defines how to calculate the height of each item
@property (nonatomic, assign) BMFMatrixFlowLayoutDelegateVerticalMode verticalMode;

@property (nonatomic, strong) BMFDeviceValue *numRows;
@property (nonatomic, strong) BMFDeviceValue *itemHeight;

/// Aspect ratio of each item for TRNColumnsLayoutDelegateVerticalModeAspectRatio vertical mode
@property (nonatomic, assign) CGFloat itemAspectRatio;

@end
