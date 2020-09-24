//
//  BMFDeviceValue.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 27/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFDeviceValue.h"

#import "NSString+BMF.h"

#import "BMFDevice.h"
#import "BMFTypes.h"

#import "BMFConditionalValue.h"

#import "BMFBlockCondition.h"
#import "BMFDeviceOrientationCondition.h"

@interface BMFDeviceValue()

@property (nonatomic, strong) NSMutableDictionary *valuesDic;

@end

@implementation BMFDeviceValue

- (void) setValue:(id)value forFamily:(BMFDeviceFamily) family {
	[self addValue:value conditions:@[ [[BMFBlockCondition alloc] initWithBlock:^BOOL(id param) {
		return ([BMFDevice currentDeviceFamily]==family);
	}] ]];
}

- (void) setValue:(id)value forFamily:(BMFDeviceFamily) family orientationAxis:(BMFDeviceOrientationAxis) orientation {
	
	[self addValue:value conditions:@[
										[[BMFBlockCondition alloc] initWithBlock:^BOOL(id param) {
											return ([BMFDevice currentDeviceFamily]==family);
										}],
										
										[[BMFDeviceOrientationCondition alloc] initWithOrientationAxis:orientation]
										
//										[[BMFBlockCondition alloc] initWithBlock:^BOOL(id param) {
//											return ([BMFDevice currentDeviceOrientationAxis]==orientation);
//										}]
										   ]];
}

- (void) setValue:(id)value forFamily:(BMFDeviceFamily) family orientationAxis:(BMFDeviceOrientationAxis) orientation batteryState:(BMFDeviceBatteryState)batteryState {
	
	
	[self addValue:value conditions:@[
										  [[BMFBlockCondition alloc] initWithBlock:^BOOL(id param) {
		return ([BMFDevice currentDeviceFamily]==family);
	}],
	  [[BMFDeviceOrientationCondition alloc] initWithOrientationAxis:orientation],

//										  [[BMFBlockCondition alloc] initWithBlock:^BOOL(id param) {
//		return ([BMFDevice currentDeviceOrientationAxis]==orientation);
//	}],
										  
										  [[BMFBlockCondition alloc] initWithBlock:^BOOL(id param) {
		return ([BMFDevice currentDeviceBatteryState]==batteryState);
	}],

										  ]];
}

- (void) setValue:(id)value forFamily:(BMFDeviceFamily) family orientationAxis:(BMFDeviceOrientationAxis) orientation batteryState:(BMFDeviceBatteryState)batteryState model:(NSString *)model {
	
	
	[self addValue:value conditions:@[
										  [[BMFBlockCondition alloc] initWithBlock:^BOOL(id param) {
		return ([BMFDevice currentDeviceFamily]==family);
	}],
//										  [[BMFBlockCondition alloc] initWithBlock:^BOOL(id param) {
//		return ([BMFDevice currentDeviceOrientationAxis]==orientation);
//	}],
  [[BMFDeviceOrientationCondition alloc] initWithOrientationAxis:orientation],
										  
										  [[BMFBlockCondition alloc] initWithBlock:^BOOL(id param) {
		return ([BMFDevice currentDeviceBatteryState]==batteryState);
	}],
										  
										  [[BMFBlockCondition alloc] initWithBlock:^BOOL(id param) {
		return ([BMFDevice currentDeviceModel]==model);
	}],
										  ]];
}

@end
