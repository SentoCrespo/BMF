//
//  BMFGradientView.h
//  xinix
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/1/15.
//  Copyright (c) 2015 Treenovum. All rights reserved.
//

#import "BMFView.h"

IB_DESIGNABLE
@interface BMFGradientView : BMFView

@property (nonatomic, strong) IBInspectable UIColor *startColor;
@property (nonatomic, strong) IBInspectable UIColor *endColor;

@end
