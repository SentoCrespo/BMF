//
//  BMFDeselectTableCellsOnAppearBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 5/3/15.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFDeselectTableCellsOnAppearBehavior : BMFViewControllerBehavior

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) IBInspectable BOOL animated;

@end
