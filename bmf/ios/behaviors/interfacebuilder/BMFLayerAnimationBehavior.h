//
//  BMFLayerAnimationBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/12/14.
//
//

#import "BMFRunAnimationBehavior.h"

/// DON't USE!!! Not working yet!!!!!!!
#warning Implement this!
@interface BMFLayerAnimationBehavior : BMFRunAnimationBehavior <BMFViewsAnimationBehaviorProtocol>

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *views;

- (IBAction)runAnimation:(id)sender;

- (id) initialValue;
- (id) finalValue;

- (NSString *) keyPath;

@end
