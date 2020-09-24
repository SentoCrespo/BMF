//
//  TRNSetting.h
//  geofence
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/09/14.
//  Copyright (c) 2014 Treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"
#import "BMFSettingProtocol.h"
#import "BMFFixedValue.h"

@interface BMFSetting : BMFFixedValue <BMFSettingProtocol>

@property (nonatomic, assign) BOOL userAdjustable;

@property (nonatomic, strong) BMFActionBlock applyValueBlock;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *key;

@property (nonatomic, strong) NSUserDefaults *userDefaults;

//@property (nonatomic, strong) id value;
@property (nonatomic, strong) id defaultValue;

- (id) rawValue;

- (instancetype) initWithKey:(NSString *) key;

- (instancetype) initWithValue:(id)value __attribute__((unavailable("Use initWithKey: instead")));
- (instancetype) init __attribute__((unavailable("Use initWithKey: instead")));

- (void) load;
- (void) save;

@end
