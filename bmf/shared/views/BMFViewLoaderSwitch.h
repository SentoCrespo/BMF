//
//  BMFViewLoaderSwitch.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 16/07/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"
#import "BMFLoaderViewProtocol.h"

/// Hides the view "view" when the loader is running
@interface BMFViewLoaderSwitch : NSObject <BMFLoaderViewProtocol>

@property (nonatomic, strong) BMFIXView<BMFLoaderViewProtocol> *loaderView;
@property (nonatomic, strong) BMFIXView *view;

- (instancetype) initWithLoaderView:(BMFIXView<BMFLoaderViewProtocol> *) loaderView view:(BMFIXView *) view;
- (instancetype) init __attribute__((unavailable("Use initWithLoaderView:view: instead")));

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) BMFProgress *progress;

@property (nonatomic, copy) BMFActionBlock reloadActionBlock;

@end
