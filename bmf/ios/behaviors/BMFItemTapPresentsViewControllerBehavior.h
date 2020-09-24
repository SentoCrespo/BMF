//
//  BMFPresentViewControllerBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/05/14.
//
//

#import "BMFItemTapBehavior.h"

#import "BMFObjectControllerProtocol.h"

typedef NS_ENUM(NSInteger, BMFPresentViewControllerBehaviorMode) {
    BMFPresentViewControllerBehaviorAutomatic,
    BMFPresentViewControllerBehaviorSegue,
	BMFPresentViewControllerBehaviorModal,
	BMFPresentViewControllerBehaviorPush
};

@interface BMFItemTapPresentsViewControllerBehavior : BMFItemTapBehavior

@property (nonatomic, assign) BMFPresentViewControllerBehaviorMode mode;

/// Identifier of the segue to be performed
@property (nonatomic, strong) NSString *segueIdentifier;

/// View controller to be pushed or presented
@property (nonatomic, strong) UIViewController<BMFObjectControllerProtocol> *detailViewController;

/// YES by default
@property (nonatomic, assign) BOOL animated;


@end
