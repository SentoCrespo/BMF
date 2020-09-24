//
//  BMFLoadCellImagesBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 5/3/15.
//
//

#import "BMFViewControllerBehavior.h"

#import "BMFTypes.h"
#import "BMFTaskProtocol.h"

typedef id<BMFTaskProtocol>(^BMFCreateImageLoadTaskBlock)(id item);

/// Loads the missing images for a table or collection view cell, changes the entity and then reloads that cell
@interface BMFLoadCellImagesBehavior : BMFViewControllerBehavior

/// The view has to be a UITableView or a UICollectionView, and it's data source must conform to protocol BMFDataReadProtocol
@property (nonatomic, weak) IBOutlet UIView *view;

/// This should be the name of the entity property for the image. It should be a UIImage
@property (nonatomic, copy) IBInspectable NSString *imagePropertyName;

/// This should be the name of the entity property for the url. It should be a NSURL
@property (nonatomic, copy) IBInspectable NSString *urlPropertyName;

/// Optional. By default it will use [[BMFBase sharedInstance].factory imageLoadTask]
@property (nonatomic, copy) BMFCreateImageLoadTaskBlock createLoadTaskBlock;

@end
