//
//  UITableViewCell+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 22/08/14.
//
//

#import "UITableViewCell+BMF.h"

@implementation UITableViewCell (BMF)

- (void) BMF_showLoadingWithStyle: (UIActivityIndicatorViewStyle) style {
	UIActivityIndicatorView *loaderView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    loaderView.frame = CGRectMake(0, 0, 40, 40);

	self.accessoryView = loaderView;
    [loaderView startAnimating];
}

- (void) BMF_hideLoading {
	self.accessoryView = nil;
}


@end
