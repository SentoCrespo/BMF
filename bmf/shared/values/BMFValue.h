//
//  BMFValue.h
//  ExampleMac
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/04/14.
//  Copyright (c) 2014 josé manuel sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFValueProtocol.h"

@interface BMFValue : NSObject <BMFValueProtocol, BMFValueChangeNotifyProtocol>

@property (nonatomic, strong) id<BMFAdapterProtocol> valueAdapter;

/// Block run when the value might have changed
@property (nonatomic, strong) BMFActionBlock applyValueBlock __deprecated;

/// Block run when set and when the value changes. Passes the final value
@property (nonatomic, strong) BMFActionBlock signalBlock;

/// Used by subclasses to prepare the value for delivery. Transforms nsnull to nil, and if the value is a bmfvalue gets its currentvalue
- (id) prepareValue:(id) value;

@end
