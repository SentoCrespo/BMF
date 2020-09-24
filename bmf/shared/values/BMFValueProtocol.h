//
//  BMFValueProtocol.h
//  ExampleMac
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/04/14.
//  Copyright (c) 2014 josé manuel sánchez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"

#import "BMFValidatorProtocol.h"
#import "BMFAdapterProtocol.h"

BMFDeclareGlobalNotificationConstant(BMFValueChangedNotification);

@protocol BMFValueProtocol <NSObject>

@property (nonatomic, strong) id<BMFAdapterProtocol> valueAdapter;

/// Retrieves the current value
- (id) currentValue;

@end

@protocol BMFValueChangeNotifyProtocol <NSObject>

/// Block run when the value might have changed. Setting the block also runs it immediately
@property (nonatomic, strong) BMFActionBlock applyValueBlock __deprecated;

/// Block run when set and when the value changes. Passes the final value
@property (nonatomic, strong) BMFActionBlock signalBlock;

/// Can be used to tell any observers of this value that it may have changed (useful if the value is an instance of a class and some property changes, for example)
- (IBAction) notifyValueChanged:(id)sender;

@end

@protocol BMFValueChangeProtocol <NSObject>

@property (nonatomic, strong) id<BMFValidatorProtocol> acceptValueValidator;

- (void) setCurrentValue:(id) value;

@end