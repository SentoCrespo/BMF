//
//  BMFTimePickActivity.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/11/14.
//
//

#import "BMFActivity.h"


@interface BMFTimePickActivity : BMFActivity

@property (nonatomic, assign) NSInteger secondsInterval;
@property (nonatomic, assign) NSInteger minutesInterval;

@property (nonatomic, assign) BMFActionBlock setupPickerViewControllerBlock;

@end
