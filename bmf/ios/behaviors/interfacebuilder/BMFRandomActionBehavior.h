//
//  BMFRandomActionBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 4/12/14.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFRandomActionBehavior : BMFViewControllerBehavior

@property (nonatomic, weak) IBOutletCollection(id) NSArray *objects;
@property (nonatomic, copy) IBInspectable NSString *actionName;

- (IBAction)run:(id)sender;

@end
