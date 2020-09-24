//
//  BMFUserMessagesPresenter.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/07/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFUserMessagesPresenterProtocol.h"

#import "BMFDataConnectionCheckerProtocol.h"

@interface BMFUserMessagesPresenter : NSObject <BMFUserMessagesPresenterProtocol>

@property (nonatomic, strong) id<BMFDataConnectionCheckerProtocol> networkChecker;

@end
