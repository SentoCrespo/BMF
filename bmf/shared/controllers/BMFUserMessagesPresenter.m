//
//  BMFUserMessagesPresenter.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/07/14.
//
//

#import "BMFUserMessagesPresenter.h"

#import "BMF.h"

#import "BMFAFNetworkingDataConnectionChecker.h"

@implementation BMFUserMessagesPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _networkChecker = [BMFAFNetworkingDataConnectionChecker new];
    }
    return self;
}

- (void) showMessage:(NSString *)message kind:(BMFUserMessagesMessageKind)kind sender:(id)sender {
	BMFAbstractMethod();
}

- (void) showMessage:(NSString *)title message:(NSString *)message kind:(BMFUserMessagesMessageKind)kind sender:(id)sender {
	BMFAbstractMethod();
}

- (void) showNetworkError:(NSString *) message sender:(id) sender {
	BOOL errorShown = [self showErrorWithoutInternet:sender];
	if (!errorShown) {
		[self showMessage:message kind:BMFUserMessagesMessageKindError sender:sender];
	}
}

- (void) showNetworkError:(NSString *)title message:(NSString *) message sender:(id) sender {
	BOOL errorShown = [self showErrorWithoutInternet:sender];
	if (!errorShown) {
		[self showMessage:title message:message kind:BMFUserMessagesMessageKindError sender:sender];
	}
}

- (BOOL) showErrorWithoutInternet:(id)sender {
	BMFAssertReturnNO(self.networkChecker);
	
	if ([self.networkChecker dataConnectionAvailable]) return NO;
	
	[self showMessage:BMFLocalized(@"No data connection available", nil) kind:BMFUserMessagesMessageKindError sender:sender];
	
	return YES;
}

@end
