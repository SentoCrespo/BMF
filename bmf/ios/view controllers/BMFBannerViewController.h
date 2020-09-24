//
//  BMFBannerViewController.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/06/14.
//
//

#import "BMFCollectionViewController.h"

typedef NS_ENUM(NSUInteger, BMFBannerViewControllerScrollDirection) {
    BMFBannerViewControllerScrollDirectionHorizontal,
    BMFBannerViewControllerScrollDirectionVertical
};

typedef void(^BMFIndexBlock)(NSInteger index);

@interface BMFBannerViewController : BMFCollectionViewController

/// If the banner will scroll through all the items automatically. NO by default
@property (nonatomic, assign) BOOL slideAutomatically;

@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

/// Time that each item is shown in the banner in seconds. 5 by default
@property (nonatomic, assign) NSUInteger slideDuration;
@property (nonatomic, assign) BMFBannerViewControllerScrollDirection scrollDirection;

@property (nonatomic, strong) Class cellClass;

/// This items should conform to protocol BMFBannerItemProtocol
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, copy) BMFActionBlock selectItemBlock;

@property (nonatomic, copy) BMFIndexBlock pageChangedBlock;

@end
