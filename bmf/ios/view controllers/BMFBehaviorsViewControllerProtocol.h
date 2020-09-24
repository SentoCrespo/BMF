//
//  BMFBehaviorsViewControllerProtocol.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/11/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFViewControllerBehaviorProtocol.h"

@protocol BMFBehaviorsViewControllerProtocol <NSObject>

- (void) addBehavior: (id<BMFViewControllerBehaviorProtocol>) behavior;
- (void) removeBehavior: (id<BMFViewControllerBehaviorProtocol>) behavior;
- (void) removeAllBehaviors;

@end
