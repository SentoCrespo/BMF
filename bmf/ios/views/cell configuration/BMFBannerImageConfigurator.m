//
//  BMFBannerImageConfigurator.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/07/14.
//
//

#import "BMFBannerImageConfigurator.h"

#import "BMFBannerItemImageProtocol.h"
#import "BMFCollectionImageViewCell.h"

#import "BMF.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation BMFBannerImageConfigurator

+ (void) load {
	[self register];
}

+ (BOOL) canConfigure:(id)view kind:(NSString *)kind withItem:(id)item inView:(id)containerView {
	return ([view isKindOfClass:[BMFCollectionImageViewCell class]] && [item conformsToProtocol:@protocol(BMFBannerItemImageProtocol)] );
}

+ (void) configure:(BMFCollectionImageViewCell *)view kind:(NSString *)kind withItem:(id<BMFBannerItemImageProtocol>)item inView:(UICollectionView *)containerView atIndexPath:(NSIndexPath *)indexPath controller:(id)controller {
	BMFAssertReturn([containerView isKindOfClass:[UICollectionView class]]);
	
	view.imageView.contentMode = UIViewContentModeScaleAspectFill;
	
	DDLogDebug(@"content mode %ld",(long)view.imageView.contentMode);
	DDLogDebug(@"user interaction enabled %d",view.imageView.userInteractionEnabled);
	
	if (item.image) {
		view.imageView.image = item.image;
	}
	else if (item.urlString.length>0) {
		if (item.placeholderImage) view.imageView.image = item.placeholderImage;
		
		id<BMFTaskProtocol> task = [[BMFBase sharedInstance].factory imageLoadTask:item.urlString parameters:nil sender:self];
		[task run:^(id result, NSError *error) {
			if (error) {
				DDLogError(@"Error loading banner image: %@",error);
				return;
			}
			
			item.image = result;
			[containerView BMF_reloadCellsAtIndexPaths:@[ indexPath ]];
//			[containerView reloadItemsAtIndexPaths:@[ indexPath ]];
		}];
	}
}

+ (NSInteger) priority {
	return BMFViewConfiguratorLibraryPriority;
}

@end
