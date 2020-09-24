//
//  BMFSettingProtocol.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/9/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFValueProtocol.h"

@protocol BMFSettingProtocol  <BMFValueProtocol, BMFValueChangeProtocol, BMFValueChangeNotifyProtocol>

/// NO by default.
@property (nonatomic, assign) BOOL userAdjustable;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *key;

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@property (nonatomic, strong) id defaultValue;

/// This method can be passed anything, like a string, even if we expect a BOOL. Each setting should try to read from it and return YES if it could parse it
- (BOOL) setDefaultRawValue:(id) value;

/// This should be a basic value that can be stored in NSUserDefaults
- (id) defaultRawValue;

/// Load setting information from dictionary
- (BOOL) loadFromDictionary:(NSDictionary *) dic;

- (instancetype) initWithKey:(NSString *) key;

- (void) load;
- (void) save;

@end
