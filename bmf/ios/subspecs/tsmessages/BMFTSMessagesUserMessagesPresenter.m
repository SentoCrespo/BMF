//
//  BMFTSMessagesUserMessagesPresenter.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/07/14.
//
//

#import "BMFTSMessagesUserMessagesPresenter.h"

#import "BMF.h"
#import "UIViewController+BMF.h"

#import <TSMessages/TSMessage.h>

@implementation BMFTSMessagesUserMessagesPresenter

- (TSMessageNotificationType) typeForKind:(BMFUserMessagesMessageKind)kind {
	if (kind==BMFUserMessagesMessageKindInfo) return TSMessageNotificationTypeMessage;
	if (kind==BMFUserMessagesMessageKindWarning) return TSMessageNotificationTypeWarning;
	if (kind==BMFUserMessagesMessageKindError) return TSMessageNotificationTypeError;
	if (kind==BMFUserMessagesMessageKindSuccess) return TSMessageNotificationTypeSuccess;
	
	return TSMessageNotificationTypeMessage;
}

- (UIViewController *) viewControllerDefiningContextFor:(UIViewController *)vc {
	while (!vc.definesPresentationContext) {
		if (vc.parentViewController) vc = vc.parentViewController;
		else if (vc.presentingViewController) vc = vc.presentingViewController;
		else return vc;
	}
	
	return vc;
}

- (void) showMessage:(NSString *) message kind:(BMFUserMessagesMessageKind)kind sender:(id)sender {
	UIViewController *vc = [UIViewController BMF_cast:sender];
	vc = [vc BMF_viewControllerDefiningContext];
	if (vc) {
		[TSMessage showNotificationInViewController:vc title:nil subtitle:message type:[self typeForKind:kind]];
	}
	else {
		[TSMessage showNotificationWithTitle:nil subtitle:message type:[self typeForKind:kind]];
	}
}

- (void) showMessage:(NSString *) title message:(NSString *) message kind:(BMFUserMessagesMessageKind)kind sender:(id)sender {
	UIViewController *vc = [UIViewController BMF_cast:sender];
	vc = [vc BMF_viewControllerDefiningContext];
	if (vc) {
		[TSMessage showNotificationInViewController:vc title:title subtitle:message type:[self typeForKind:kind]];
	}
	else {
		[TSMessage showNotificationWithTitle:title subtitle:message type:[self typeForKind:kind]];
	}
}

@end
