//
//  BMFCollectionViewImageCellConfigurator.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 13/05/14.
//
//

#import "BMFCollectionViewImageCellConfigurator.h"

#import "BMFCollectionImageViewCell.h"

@implementation BMFCollectionViewImageCellConfigurator

+ (void) load {
	[self register];
}

+ (Class) viewClass {
	return [BMFCollectionImageViewCell class];
}

+ (Class) itemClass {
	return [UIImage class];
}

+ (void) configure:(BMFCollectionImageViewCell *)view kind:(NSString *)kind withItem:(UIImage *)item inView:(UIView *)containerView atIndexPath:(NSIndexPath *)indexPath controller:(id)controller {
	view.imageView.image = item;
}

+ (NSInteger) priority {
	return BMFViewConfiguratorLibraryPriority;
}

@end
