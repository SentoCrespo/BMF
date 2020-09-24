//
//  BMFSettingsConfigurationModule.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/10/14.
//
//

#import "BMFConfiguration.h"

#import "BMFConfigurationProtocol.h"

@interface BMFSettingsConfigurationModule : NSObject <BMFConfigurationProtocol>

/// By default this will be the url of a resource file named: "settings.json"
@property (nonatomic, strong) NSURL *resourceSettingsUrl;

/// By default this will be nil. Change this to update the settings from a remote server
@property (nonatomic, strong) NSURL *remoteSettingsUrl;

/// Path to which the resource and remote settings will be saved to. By default appDocuments/bmf/settings.json
@property (nonatomic, strong) NSURL *localSettingsUrl;

@end
