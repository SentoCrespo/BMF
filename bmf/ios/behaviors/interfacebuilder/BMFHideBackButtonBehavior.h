//
//  BMFDisableBackButtonBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/12/14.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFHideBackButtonBehavior : BMFViewControllerBehavior

@property (nonatomic, assign) IBInspectable BOOL showButton;
@property (nonatomic, assign) IBInspectable BOOL animated;

@end
