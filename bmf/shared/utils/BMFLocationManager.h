//
//  BMFLocationManager.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/07/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"

@import CoreLocation;

@interface BMFLocationManager : NSObject

/// Current user location if it could be retrieved
@property (nonatomic, readonly) CLLocation *currentLocation;

/// To be called when the location or the authorization level change
@property (nonatomic, copy) BMFActionBlock actionBlock;

/// Interval that has to pass to discard the last location. If it's too old it won't be valid anymore. Set to 0 to never discard it. 15 minutes by default (15*60)
@property (nonatomic, assign) NSTimeInterval staleInterval;

/// Minimum required accuracy to consider a location valid. 1000 meters by default
@property (nonatomic, assign) CLLocationAccuracy minimumAccuracy;

@property (nonatomic, readonly) BOOL authorized;

- (instancetype) initWithBlock:(BMFActionBlock) actionBlock;
- (instancetype) init __attribute__((unavailable("Use initWithBlock: instead")));

- (void) start;
/// Runs until it gets one valid location
- (void) findOne;
- (void) stop;

@end
