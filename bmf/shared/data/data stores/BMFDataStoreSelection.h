//
//  BMFDataStoreSelection.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/07/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFDataStoreSelectionProtocol.h"

@interface BMFDataStoreSelection : NSObject <BMFDataStoreSelectionProtocol>

/// BMFDataStoreSelectionModeMultiple by default
@property (nonatomic, assign) BMFDataStoreSelectionMode mode;

@property (nonatomic, strong) NSArray *selection;

@end
