//
//  BMFTableViewHideSeparatorsForEmptyCellsBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/12/14.
//
//

#import "BMFTableViewHideSeparatorsForEmptyCellsBehavior.h"

#import "BMF.h"
#import "UITableView+BMF.h"

@implementation BMFTableViewHideSeparatorsForEmptyCellsBehavior

- (void) performInit {
	[super performInit];
	
	self.hidesOnLoad = YES;
}

- (void) viewDidLoad {
	if (self.hidesOnLoad) [self hideSeparators:self];
}

- (IBAction)showSeparators:(id)sender {
	if (!self.isEnabled) return;
	
	BMFAssertReturn(self.tableView);
	
	[self.tableView BMF_showSeparatorsForEmptyCells];
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (IBAction)hideSeparators:(id)sender {
	if (!self.isEnabled) return;
	
	BMFAssertReturn(self.tableView);
	
	[self.tableView BMF_hideSeparatorsForEmptyCells];
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
