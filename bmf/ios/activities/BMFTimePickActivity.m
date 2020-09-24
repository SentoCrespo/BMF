//
//  BMFTimePickActivity.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/11/14.
//
//

#import "BMFTimePickActivity.h"

#import "BMF.h"
#import "BMFTimePickerViewController.h"
#import "BMFTimePickerView.h"

@interface BMFTimePickActivity()

@property (nonatomic, copy) BMFCompletionBlock completionBlock;
@property (nonatomic, strong) BMFTimePickerViewController *pickerVC;

@end

@implementation BMFTimePickActivity

- (void) run:(BMFCompletionBlock)completionBlock {
	BMFAssertReturn(self.viewController);
	BMFAssertReturn(completionBlock);
	
	if (self.minutesInterval==0) self.minutesInterval = 1;
	if (self.secondsInterval==0) self.secondsInterval = 5;
	
	self.completionBlock = completionBlock;
	
	self.pickerVC = [BMFTimePickerViewController new];
	
	if (self.setupPickerViewControllerBlock) self.setupPickerViewControllerBlock(self.pickerVC);

	[self.viewController presentViewController:_pickerVC animated:YES completion:^{
		_pickerVC.picker.minutesInterval = self.minutesInterval;
		_pickerVC.picker.secondsInterval = self.secondsInterval;
		[_pickerVC.selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
		[_pickerVC.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
	}];
}


- (IBAction)select:(id)sender {
	id result = @(self.pickerVC.picker.selectedTimeInterval);
	[self.viewController dismissViewControllerAnimated:YES completion:^{
		self.completionBlock(result,nil);
	}];
}

- (IBAction)cancel:(id)sender {
	[self.viewController dismissViewControllerAnimated:YES completion:^{
		self.completionBlock(nil,[NSError errorWithDomain:@"Activity" code:BMFErrorCancelled userInfo:@{ NSLocalizedDescriptionKey : BMFLocalized(@"User Cancelled",nil) }]);
	}];
}

@end
