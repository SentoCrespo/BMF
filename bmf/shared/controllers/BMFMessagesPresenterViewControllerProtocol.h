//
//  BMFMessagesPresenterViewControllerProtocol.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/07/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFUserMessagesPresenterProtocol.h"

@protocol BMFMessagesPresenterViewControllerProtocol <NSObject>

@property (nonatomic, strong) id<BMFUserMessagesPresenterProtocol> messagePresenter;

@end
