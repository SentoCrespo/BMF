//
//  BMFStopEditingBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/11/14.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFStopEditingBehavior : BMFViewControllerBehavior

@property (nonatomic, assign) IBInspectable BOOL forceStopEditing;

- (IBAction) stopEditing:(id)sender;

@end
