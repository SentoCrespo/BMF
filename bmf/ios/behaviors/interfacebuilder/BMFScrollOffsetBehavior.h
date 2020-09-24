//
//  BMFScrollOffsetBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/11/14.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFScrollOffsetBehavior : BMFViewControllerBehavior <UIScrollViewDelegate>

// Minimum offset to throw event behavior. 0,60 by default
@property (nonatomic, assign) IBInspectable CGPoint minimumOffset;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end
