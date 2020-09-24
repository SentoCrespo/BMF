//
//  BMFMessagePresenterFactoryProtocol.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/07/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFUserMessagesPresenterProtocol.h"

@protocol BMFMessagePresenterFactoryProtocol <NSObject>

- (id<BMFUserMessagesPresenterProtocol>) defaultUserMessagesPresenter;

@end
