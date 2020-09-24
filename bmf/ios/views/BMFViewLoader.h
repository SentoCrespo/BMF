//
//  BMFViewLoader.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/3/15.
//
//

#import <UIKit/UIKit.h>

#import "BMFLoaderViewProtocol.h"

@interface BMFViewLoader : NSObject <BMFLoaderViewProtocol>

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) BMFProgress *progress;

@property (nonatomic, copy) BMFActionBlock reloadActionBlock;

/// This view can be a UIProgress or a UIActivityIndicatorView
@property (nonatomic, weak) UIView *view;

@end
