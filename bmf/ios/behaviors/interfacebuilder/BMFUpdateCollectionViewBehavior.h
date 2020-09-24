//
//  BMFUpdateCollectionViewBehavior.h
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFViewControllerBehavior.h"

/// This behavior updates the collectionview layout when the rotation changes
@interface BMFUpdateCollectionViewBehavior : BMFViewControllerBehavior

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end
