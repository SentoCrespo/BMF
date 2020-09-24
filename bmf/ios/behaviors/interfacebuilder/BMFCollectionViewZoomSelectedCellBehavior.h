//
//  BMFCollectionViewZoomSelectedCellBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/07/14.
//
//

#import "BMFItemTapBehavior.h"

#import "BMFObjectControllerProtocol.h"

@interface BMFCollectionViewZoomSelectedCellBehavior : BMFItemTapBehavior <BMFObjectControllerProtocol>

/// Stores the selected item if one was selected
@property (nonatomic, strong) BMFObjectDataStore *objectStore;

- (IBAction)stopZooming:(id)sender;

@end
