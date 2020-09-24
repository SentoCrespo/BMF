//
//  BMFEmptyViewHideViewsBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/2/15.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFEmptyViewHideViewsBehavior : BMFViewControllerBehavior

@property (nonatomic, weak) IBOutlet UIView *sourceView;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *views;

@property (nonatomic) IBInspectable BOOL animated;

@property (nonatomic) IBInspectable CGFloat animationDuration;

@end
