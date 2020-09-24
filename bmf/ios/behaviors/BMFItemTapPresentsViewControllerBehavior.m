//
//  BMFPresentViewControllerBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/05/14.
//
//

#import "BMFItemTapPresentsViewControllerBehavior.h"

#import "BMFTypes.h"

#import "BMFObjectControllerProtocol.h"
#import "BMFViewController.h"

@implementation BMFItemTapPresentsViewControllerBehavior

- (instancetype)init
{
    self = [super init];
    if (self) {
        _animated = YES;
    }
    return self;
}

- (void) itemTapped:(id) item atIndexPath:(NSIndexPath *)indexPath containerView:(UIView *)containerView {

	BMFAssertReturn(self.object);

	BMFPresentViewControllerBehaviorMode currentMode = self.mode;
	
	if (self.mode==BMFPresentViewControllerBehaviorAutomatic) {
		if (self.segueIdentifier.length>0) currentMode = BMFPresentViewControllerBehaviorSegue;
		else if (self.object.navigationController) currentMode = BMFPresentViewControllerBehaviorPush;
		else currentMode = BMFPresentViewControllerBehaviorModal;
	}

	
	if (currentMode==BMFPresentViewControllerBehaviorSegue) {
		BMFAssertReturn(self.segueIdentifier.length>0);

		BMFViewController *vc = [BMFViewController BMF_cast:self.object];
		BMFAssertReturn(vc);
		[vc performSegueWithIdentifier:self.segueIdentifier prepareBlock:^(UIStoryboardSegue *segue) {
			UIViewController *detailVC = segue.destinationViewController;
			BMFAssertReturn([detailVC conformsToProtocol:@protocol(BMFObjectControllerProtocol)]);
			
			id<BMFObjectControllerProtocol> destinationVC = (id)detailVC;
			destinationVC.objectStore.value = item;
		}];
	}
	else if (currentMode==BMFPresentViewControllerBehaviorModal) {
		BMFAssertReturn(self.detailViewController);
		
		self.detailViewController.objectStore.value = item;
		
		[self.object presentViewController:self.detailViewController animated:self.animated completion:nil];
	}
	else if (currentMode==BMFPresentViewControllerBehaviorPush) {
		BMFAssertReturn(self.detailViewController);

		self.detailViewController.objectStore.value = item;
		[self.object.navigationController pushViewController:self.detailViewController animated:self.animated];
	}
	else {
		[NSException raise:@"Unknown format for present view controller" format:@"%@",self];
	}
}


@end
