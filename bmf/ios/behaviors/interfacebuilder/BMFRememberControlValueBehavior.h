//
//  BMFRememberControlStateBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/3/15.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFRememberControlValueBehavior : BMFViewControllerBehavior

@property (nonatomic, weak) IBOutlet UIControl *control;

/// Used to store and load the value
@property (nonatomic,copy) IBInspectable NSString *key;


@end
