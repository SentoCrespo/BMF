//
//  BMFUserMessagesPresenter.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/07/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFDataConnectionCheckerProtocol.h"

typedef NS_ENUM(NSUInteger, BMFUserMessagesMessageKind) {
    BMFUserMessagesMessageKindInfo,
    BMFUserMessagesMessageKindWarning,
    BMFUserMessagesMessageKindError,
    BMFUserMessagesMessageKindSuccess
};

@protocol BMFUserMessagesPresenterProtocol <NSObject>

/// This is used for checking the network status
@property (nonatomic, strong) id<BMFDataConnectionCheckerProtocol> networkChecker;

/// Sender should be the view controller
- (void) showMessage:(NSString *) message kind:(BMFUserMessagesMessageKind)kind sender:(id) sender;

/// Sender should be the view controller
- (void) showMessage:(NSString *) title message:(NSString *) message kind:(BMFUserMessagesMessageKind)kind sender:(id) sender;

/// If there is no network connection shows the error without internet, otherwise shows this message
- (void) showNetworkError:(NSString *) message sender:(id) sender;

/// If there is no network connection shows the error without internet, otherwise shows this title and message
- (void) showNetworkError:(NSString *) title message:(NSString *) message sender:(id) sender;

/// Checks if there is a data connection, and shows an error if there isn't. Returns YES if the message is displayed. Sender should be the view controller
- (BOOL) showErrorWithoutInternet:(id) sender;

@end
