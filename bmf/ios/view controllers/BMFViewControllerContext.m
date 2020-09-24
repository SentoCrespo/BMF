//
//  BMFViewControllerContext.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/07/14.
//
//

#import "BMFViewControllerContext.h"

#import "BMF.h"
#import "BMFMessagesPresenterViewControllerProtocol.h"
#import "BMFObjectControllerProtocol.h"

@implementation BMFViewControllerContext

+ (BMFViewControllerContext *) contextFromViewController:(UIViewController *) viewController {
	BMFViewControllerContext *context = [BMFViewControllerContext new];
	
	[context loadFrom:viewController];
	
	return context;
}

- (NSArray *) apply:(UIViewController *) viewController {
	
	NSArray *viewControllers = [BMFUtils extractDetailViewControllers:viewController];
	
	for (UIViewController *detailViewController in viewControllers) {
		UIViewController<BMFMessagesPresenterViewControllerProtocol> *messagesVC = [detailViewController BMF_castWithProtocol:@protocol(BMFMessagesPresenterViewControllerProtocol)];
		messagesVC.messagePresenter = self.messagePresenter;
		
		
		UIViewController<BMFObjectControllerProtocol> *objectVC = [detailViewController BMF_castWithProtocol:@protocol(BMFObjectControllerProtocol)];
		objectVC.objectStore.currentValue = self.detailItem;
		
		if (self.detailItem && !objectVC) {
			BMFLogWarnC(BMFLogUIContext, @"Detail item set but destination vc doesn't support the objectcontroller protocol");
		}
	}
	
	return viewControllers;
}

- (void) loadFrom:(UIViewController *) viewController {
	
	UIViewController<BMFMessagesPresenterViewControllerProtocol> *messagesVC = [viewController BMF_castWithProtocol:@protocol(BMFMessagesPresenterViewControllerProtocol)];
	self.messagePresenter = messagesVC.messagePresenter;

	UIViewController<BMFObjectControllerProtocol> *objectVC = [viewController BMF_castWithProtocol:@protocol(BMFObjectControllerProtocol)];
	self.detailItem = objectVC.objectStore.currentValue;
}

@end
