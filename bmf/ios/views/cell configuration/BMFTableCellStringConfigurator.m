//
//  BMFTableCellStringConfigurator.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 3/10/14.
//
//

#import "BMFTableCellStringConfigurator.h"

@implementation BMFTableCellStringConfigurator

+ (void) load {
	[self register];
}

+ (Class) viewClass {
	return [UITableViewCell class];
}

+ (Class) itemClass {
	return [NSString class];
}

+ (void) configure:(UITableViewCell *)view kind:(NSString *)kind withItem:(NSString *)item inView:(UIView *)containerView atIndexPath:(NSIndexPath *)indexPath controller:(id)controller {
	view.textLabel.text = item;
}

+ (NSInteger) priority {
	return BMFViewConfiguratorLibraryPriority;
}

@end
