//
//  TRNRangeValueSetting.h
//  geofence
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/09/14.
//  Copyright (c) 2014 Treenovum. All rights reserved.
//

#import "BMFSetting.h"

@interface BMFRangeValueSetting : BMFSetting

@property (nonatomic, strong) NSNumber *minValue;
@property (nonatomic, strong) NSNumber *maxValue;
@property (nonatomic, strong) NSNumber *value;

@end
