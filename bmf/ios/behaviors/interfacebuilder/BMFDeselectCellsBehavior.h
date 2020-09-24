//
//  BMFDeselectTableCellsOnAppearBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 17/2/15.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFDeselectCellsBehavior : BMFViewControllerBehavior

@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic) IBInspectable BOOL animated;

- (IBAction) deselect:(id)sender;

@end
