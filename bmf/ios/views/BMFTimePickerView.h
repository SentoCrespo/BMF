//
//  BMFTimePickerView.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/11/14.
//
//

#import <UIKit/UIKit.h>

#import "BMFTypes.h"

IB_DESIGNABLE
@interface BMFTimePickerView : UIPickerView

// Interval between seconds. 5 By default
@property (nonatomic, assign) IBInspectable NSInteger secondsInterval;

// Interval between minutes. 1 By default
@property (nonatomic, assign) IBInspectable NSInteger minutesInterval;

// Value to be read or set
@property (nonatomic, assign) NSTimeInterval selectedTimeInterval;

@property (nonatomic, copy) BMFActionBlock didChangeSelectionBlock;

@end
