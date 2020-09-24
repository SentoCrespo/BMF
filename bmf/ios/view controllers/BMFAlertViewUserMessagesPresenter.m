//
//  BMFAlertViewUserMessagesPresenter.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/07/14.
//
//

#import "BMFAlertViewUserMessagesPresenter.h"

#import "BMFAlertView.h"
#import "BMF.h"

@interface BMFAlertViewUserMessagesPresenter()

@property (nonatomic) BOOL presentingMessage;

@end

@implementation BMFAlertViewUserMessagesPresenter

- (void) showMessage:(NSString *) message kind:(BMFUserMessagesMessageKind)kind sender:(id)sender {
	if (self.presentingMessage) return;
	self.presentingMessage = YES;
	BMFAlertView *alertView = [[BMFAlertView alloc] initWithTitle:nil message:message];
	[alertView BMF_addCancelButtonWithTitle:BMFLocalized(@"Close", nil) actionBlock:^(id sender) {
		self.presentingMessage = NO;
	}];
	[alertView show];
}

- (void) showMessage:(NSString *) title message:(NSString *) message kind:(BMFUserMessagesMessageKind)kind sender:(id)sender {
	if (self.presentingMessage) return;
	self.presentingMessage = YES;
	BMFAlertView *alertView = [[BMFAlertView alloc] initWithTitle:title message:message];
	[alertView BMF_addCancelButtonWithTitle:BMFLocalized(@"Close", nil) actionBlock:^(id sender) {
		self.presentingMessage = NO;
	}];
	[alertView show];
}


@end
