//
//  BMFEnumerateDataSourceAspect.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/06/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"
#import "BMFCondition.h"
#import "BMFActionableProtocol.h"
#import "BMFAspect.h"

typedef NS_ENUM(NSUInteger, BMFEnumerateDataSourceAspectMode) {
    BMFEnumerateDataSourceAspectModeForward,
    BMFEnumerateDataSourceAspectModeBackward
};

@interface BMFEnumerateDataSourceAspect : BMFAspect <BMFActionableProtocol>

/// BMFEnumerateDataSourceAspectModeForward by default
@property (nonatomic, assign) BMFEnumerateDataSourceAspectMode mode;

/// Condition to be met for continuing enumeration. BMFConditionTrue by default
@property (nonatomic, strong) BMFCondition *condition;


@property (nonatomic, readonly) NSIndexPath *indexPath;

/// Returns an indexPath pointing to the next item in the data source.
- (void) action:(id) input completion:(BMFCompletionBlock) completion;


@end
