//
//  BMFAudioRecordActivity.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/08/14.
//
//

#import "BMFAudioRecordActivity.h"

#import "BMF.h"
#import "BMFUtils.h"
#import "BMFAudioRecordViewController.h"

@interface BMFAudioRecordActivity()

@end

@implementation BMFAudioRecordActivity

- (instancetype)init {
    self = [super init];
    if (self) {
		_startImmediately = YES;
		_useAudioTitle = BMFLocalized(@"Save", nil);
    }
    return self;
}

- (void) run:(BMFCompletionBlock)completionBlock {
	
	BMFAssertReturn(self.viewController);
	BMFAssertReturn(completionBlock);

	UIViewController *presenterVC = self.viewController;
	if (self.viewController.BMF_parentViewController) presenterVC = self.viewController.BMF_parentViewController;

	BMFAssertReturn(presenterVC);

//	BMFAudioRecordViewController *audioRecordVC = [[BMFAudioRecordViewController alloc] initWithNibName:@"BMFAudioRecordViewController" bundle:[BMFBase sharedInstance].bundle];
	BMFAudioRecordViewController *audioRecordVC = [BMFAudioRecordViewController new];
	audioRecordVC.useAudioTitle = self.useAudioTitle;
	
	audioRecordVC.cancelBlock = ^(id vc) {
		completionBlock(nil,[NSError errorWithDomain:@"Activity" code:BMFErrorCancelled userInfo:nil]);
	};
	
	audioRecordVC.useAudioBlock = ^(NSURL *fileUrl) {
		completionBlock(fileUrl,nil);
	};
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:audioRecordVC];
	[self.viewController presentViewController:navController animated:YES completion:nil];
}



@end
