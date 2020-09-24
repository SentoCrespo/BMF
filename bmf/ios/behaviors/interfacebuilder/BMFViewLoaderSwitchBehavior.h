//
//  BMFViewLoaderSwitchBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/07/14.
//
//

#import "BMFViewControllerBehavior.h"

#import "BMFLoaderViewProtocol.h"

@interface BMFViewLoaderSwitchBehavior : BMFViewControllerBehavior

@property (nonatomic, weak) IBOutlet UIView<BMFLoaderViewProtocol> *loaderView;
@property (nonatomic, weak) IBOutlet UIView *view;

@end
