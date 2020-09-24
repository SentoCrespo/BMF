//
//  BMFHideEmptyViewBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/07/14.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFHideEmptyViewBehavior : BMFViewControllerBehavior

@property (nonatomic, weak) IBOutlet UIView *view;

/// Set this property to have a view shown in place of the view, when it's is hidden
@property (nonatomic, weak) IBOutlet UIView *placeholderView;

@end
