//
//  BMFViewControllerContext.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/07/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFUserMessagesPresenterProtocol.h"

//@class BMFViewControllerContext;

//@protocol BMFViewControllerContextProtocol <NSObject>
//
//- (void) setContext:(BMFViewControllerContext *) context;
//
//@end


@interface BMFViewControllerContext : NSObject

@property (nonatomic, strong) id<BMFUserMessagesPresenterProtocol> messagePresenter;
@property (nonatomic, strong) id detailItem;

+ (BMFViewControllerContext *) contextFromViewController:(UIViewController *) viewController;

/// Returns the view controllers to which the context has been applied. It will be different from "viewController" if it is a view controller container. If it's a tab controller all its view controllers will be returned here
- (NSArray *) apply:(UIViewController *) viewController;
- (void) loadFrom:(UIViewController *) viewController;


@end
