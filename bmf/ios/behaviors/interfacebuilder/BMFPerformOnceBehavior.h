//
//  BMFPerformOnceBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 4/2/15.
//
//

#import "BMFViewControllerBehavior.h"

/// This behavior sends its EventValue changed only once
@interface BMFPerformOnceBehavior : BMFViewControllerBehavior

/// Key to identify the task so we won't repeat it again. Required for performOnce and performOncePerVersion
@property (nonatomic, copy) IBInspectable NSString *taskId;

- (IBAction) performOnce:(id)sender;
- (IBAction) performOncePerVersion:(id)sender;
- (IBAction) performOncePerBuild:(id)sender;
- (IBAction) performOncePerLaunch:(id)sender;

/// Reset the task id so it will run again
- (IBAction) reset:(id)sender;

@end
