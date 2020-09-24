//
//  BMFImageBannerViewController.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/07/14.
//
//

#import "BMFImageBannerViewController.h"

#import "BMFCollectionImageViewCell.h"
#import "BMFBannerItemImageProtocol.h"

@interface BMFImageBannerViewController ()

@end

@implementation BMFImageBannerViewController

- (void) setItems:(NSArray *)items {
//	if (items.count>0) {
//		BMFAssertReturn([items.firstObject conformsToProtocol:@protocol(BMFBannerItemImageProtocol)]);
//	}
	
	[super setItems:items];
}

- (void) performInit {
	[super performInit];
	self.cellClass = [BMFCollectionImageViewCell class];
}

- (void) viewDidLoad {
	[super viewDidLoad];
	
	
}

@end
