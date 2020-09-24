//
//  BMFRemoveBehaviorBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/11/14.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFRemoveBehaviorBehavior : BMFViewControllerBehavior

@property (nonatomic, strong) IBOutletCollection(BMFViewControllerBehavior) NSArray *behaviorsToRemove;

- (IBAction) removeBehaviors:(id) sender;

@end
