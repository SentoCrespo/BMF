//
//  BMFEnableControlBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/11/14.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFEnableControlBehavior : BMFViewControllerBehavior

@property (nonatomic, weak) IBOutletCollection(UIControl) NSArray *controls;

- (IBAction)enable:(id) sender;
- (IBAction)disable:(id) sender;

@end
