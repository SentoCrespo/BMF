//
//  BMFCycleTextFieldsBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 28/1/15.
//
//

#import "BMFViewControllerBehavior.h"

/// When the user hits the return key on each of the textfields it goes to the next one
@interface BMFCycleTextFieldsBehavior : BMFViewControllerBehavior

/// If YES it will go to the first after the last is returned
@property (nonatomic, assign) IBInspectable BOOL wrapAround;

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *textFields;


@end
