//
//  BMFSettingsManager.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/9/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"
#import "BMFSettingProtocol.h"
#import "BMFTaskProtocol.h"
#import "BMFSettingsManagerProtocol.h"

@interface BMFSettingsManager : NSObject <BMFSettingsManagerProtocol>

@property (nonatomic, strong) NSUserDefaults *userDefaults;

/// Array of BMFSettings
@property (nonatomic, strong) NSDictionary *settingsDic;

/// This file path url will be used to store the local and remote configurations
@property (nonatomic, strong) NSURL *localFileUrl;

@end
