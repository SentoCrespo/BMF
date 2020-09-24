//
//  BMFLocationManager.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/07/14.
//
//

#import "BMFLocationManager.h"

#import "BMF.h"

@import MapKit;
@import CoreLocation;

@interface BMFLocationManager() <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, assign) BOOL authorized;
@property (nonatomic, assign) BOOL findingOne;

@end

@implementation BMFLocationManager

- (instancetype) initWithBlock:(BMFActionBlock) actionBlock {
	BMFAssertReturnNil(actionBlock);
	
	self = [super init];
	if (self) {
		_actionBlock = [actionBlock copy];
		
		_staleInterval = 15*60;
		_locationManager = [CLLocationManager new];
		_locationManager.delegate = self;
#if TARGET_OS_IPHONE
		if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
			[_locationManager requestWhenInUseAuthorization];
		}
#endif
		_minimumAccuracy = 1000;
	}
	return self;
}

- (void) setActionBlock:(BMFActionBlock)actionBlock {
	BMFAssertReturn(actionBlock);
	
	_actionBlock = [actionBlock copy];
}

- (CLLocation *) currentLocation {
	if (fabs([_currentLocation.timestamp timeIntervalSinceNow])>self.staleInterval) return nil;
	if (_currentLocation.horizontalAccuracy>_minimumAccuracy) return nil;
	return _currentLocation;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	self.currentLocation = locations.lastObject;
	if (self.currentLocation && self.findingOne) {
		[self stop];
	}
	self.actionBlock(self);
}

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
#if TARGET_OS_IPHONE
	self.authorized = (status==kCLAuthorizationStatusAuthorizedWhenInUse || status==kCLAuthorizationStatusAuthorizedAlways);
#else
	self.authorized = (status==kCLAuthorizationStatusAuthorized);
#endif
	self.actionBlock(self);
}

- (void) start {
	
	
	[self.locationManager startUpdatingLocation];
}

- (void) findOne {
	_findingOne = YES;
	[self start];
}

- (void) stop {
	[self.locationManager stopUpdatingLocation];
}

@end
