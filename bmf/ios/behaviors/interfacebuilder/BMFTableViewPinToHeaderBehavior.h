//
//  BMFTableViewPinToHeaderBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/06/14.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFTableViewPinToHeaderBehavior : BMFViewControllerBehavior <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
