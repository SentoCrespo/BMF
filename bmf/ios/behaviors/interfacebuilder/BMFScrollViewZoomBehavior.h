//
//  BMFScrollViewZooomBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 3/3/15.
//
//

#import "BMFViewControllerBehavior.h"

/// IMPORTANT! You must change the scroll view maximum zoom to be more than 1 or it won't work
@interface BMFScrollViewZoomBehavior : BMFViewControllerBehavior

@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UIView *zoomedView;

@end
