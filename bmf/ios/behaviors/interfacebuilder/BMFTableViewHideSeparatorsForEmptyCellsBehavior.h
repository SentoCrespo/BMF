//
//  BMFTableViewHideSeparatorsForEmptyCellsBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/12/14.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFTableViewHideSeparatorsForEmptyCellsBehavior : BMFViewControllerBehavior

@property (nonatomic, weak) IBOutlet UITableView *tableView;

/// YES by default
@property (nonatomic, assign) IBInspectable BOOL hidesOnLoad;

- (IBAction)showSeparators:(id)sender;
- (IBAction)hideSeparators:(id)sender;

@end
