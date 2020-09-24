//
//  BMFDatePickerActivity.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 19/11/14.
//
//

#import "BMFDatePickerActivity.h"

#import "BMF.h"

#import <RMDateSelectionViewController/RMDateSelectionViewController.h>

@interface BMFDatePickerActivity() <RMDateSelectionViewControllerDelegate>

@property (nonatomic, strong) RMDateSelectionViewController *dateSelector;
@property (nonatomic, copy) BMFCompletionBlock completionBlock;

@end

@implementation BMFDatePickerActivity

- (void) run:(BMFCompletionBlock)completionBlock {
	
	BMFAssertReturn(self.viewController);
	BMFAssertReturn(completionBlock);
	
	self.completionBlock = completionBlock;

	self.dateSelector = [RMDateSelectionViewController dateSelectionController];
	self.dateSelector.delegate = self;
	[self.dateSelector showFromViewController:self.viewController];
	
	self.dateSelector.datePicker.datePickerMode = self.mode;
}

#pragma mark - RMDateSelectionViewController Delegates
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
	if (self.mode==UIDatePickerModeCountDownTimer) {
		self.completionBlock(@(vc.datePicker.countDownDuration),nil);
	}
	else {
		self.completionBlock(aDate,nil);
	}
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
	self.completionBlock(nil,[NSError errorWithDomain:@"Date Picker" code:BMFErrorCancelled userInfo:@{ NSLocalizedDescriptionKey: BMFLocalized(@"User cancelled", nil) }]);
}

@end
