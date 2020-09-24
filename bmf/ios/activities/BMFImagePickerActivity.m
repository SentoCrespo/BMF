//
//  BMFImagePickerActivity.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 06/05/14.
//
//

#import "BMFImagePickerActivity.h"

#import "UIViewController+BMF.h"

@interface BMFImagePickerActivity() <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, copy) BMFCompletionBlock activityCompletionBlock;

@end

@implementation BMFImagePickerActivity

- (instancetype)init
{
    self = [super init];
    if (self) {
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			self.sourceType = UIImagePickerControllerSourceTypeCamera;
		}
		else {
			self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
		
		self.qualityType = UIImagePickerControllerQualityTypeHigh;
		self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    return self;
}

- (void) run:(BMFCompletionBlock)completionBlock {
	
	BMFAssertReturn(self.viewController);
	BMFAssertReturn(completionBlock);

	self.activityCompletionBlock = completionBlock;
	
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	imagePicker.sourceType = self.sourceType;
	imagePicker.allowsEditing = self.allowsEditing;
	
	imagePicker.modalPresentationStyle = self.modalPresentationStyle;
	
	UIViewController *presenterVC = self.viewController;
	if (self.viewController.BMF_parentViewController) presenterVC = self.viewController.BMF_parentViewController;
	
	[presenterVC presentViewController:imagePicker animated:YES completion:^{
		if (self.imagePickerPresentedBlock) self.imagePickerPresentedBlock(imagePicker);
	}];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	DDLogInfo(@"did finish");
	id result = nil;
	
	result = info[UIImagePickerControllerEditedImage];
	if (!result) result = info[UIImagePickerControllerOriginalImage];
	if (!result) result = info[UIImagePickerControllerMediaURL];
	if (!result) result = info[UIImagePickerControllerReferenceURL];
	
	self.activityCompletionBlock(result,nil);
	
	[self.viewController dismissViewControllerAnimated:YES completion:nil];
	
	[self completed];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	DDLogInfo(@"did cancel");
	self.activityCompletionBlock(nil,[NSError errorWithDomain:@"Activity" code:BMFErrorCancelled userInfo:nil]);
	[self.viewController dismissViewControllerAnimated:YES completion:nil];
	
	[self completed];
}

- (void) dealloc {
	DDLogInfo(@"dealloc image picker activity");
}

- (BOOL) isSourceTypeAvailable:(UIImagePickerControllerSourceType) sourceType {
	return [UIImagePickerController isSourceTypeAvailable:sourceType];
}

@end
