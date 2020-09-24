//
//  BMFSettingsManagerProtocol.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/10/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"
#import "BMFSettingProtocol.h"
#import "BMFTaskProtocol.h"
#import "BMFValidatorProtocol.h"

@protocol BMFSettingsManagerProtocol <NSObject, BMFValidatorProtocol>

- (id<BMFSettingProtocol>) settingWithKey:(NSString *) key;

- (NSArray *) allSettings;
- (NSArray *) userAdjustableSettings;

/// The data should be a json containing a dictionary
- (void) loadFromData:(NSData *)data completion:(BMFCompletionBlock) completionBlock;

@end
