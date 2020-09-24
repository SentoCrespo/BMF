//
//  BMFBlockViewRegister.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/5/15.
//
//

#import <Foundation/Foundation.h>
#import "BMFViewRegisterProtocol.h"

typedef void(^BMFViewRegisterBlock)(UIView *containerView);
typedef NSString *(^BMFViewIdBlock)(NSString *kind,NSIndexPath *indexPath);
typedef UIView *(^BMFRetrieveViewBlock)(NSString *kind,NSIndexPath *indexPath);

@interface BMFBlockViewRegister : NSObject <BMFViewRegisterProtocol>

@property (nonatomic, copy) BMFRetrieveViewBlock retrieveCellBlock;

- (instancetype) initWithRegisterBlock:(BMFViewRegisterBlock) registerBlock dequeueBlock:(BMFViewIdBlock) viewIdBlock;
- (instancetype) init __attribute__((unavailable("Use initWithRegisterBlock:dequeueBlock: instead")));

@end
