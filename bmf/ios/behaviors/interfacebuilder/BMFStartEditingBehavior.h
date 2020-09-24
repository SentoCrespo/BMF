//
//  BMFStartEditingBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/11/14.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFStartEditingBehavior : BMFViewControllerBehavior

@property (nonatomic, strong) IBOutlet UIControl *control;

- (IBAction) startEditing:(id)sender;

@end
