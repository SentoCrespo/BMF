//
//  BMFResponderChainBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/07/14.
//
//

#import "BMFViewControllerBehavior.h"

#import "BMFTypes.h"

@interface BMFResponderChainBehavior : BMFViewControllerBehavior

@property (nonatomic, strong) IBOutletCollection(UIResponder) NSArray *responders;

/// If YES it will go to the first after the last is returned
@property (nonatomic, assign) IBInspectable BOOL wrapAround;

@property (nonatomic, assign) IBInspectable UIReturnKeyType lastResponderReturnKeyType;

@property (nonatomic, copy) BMFActionBlock lastResponderActionBlock;

@end
