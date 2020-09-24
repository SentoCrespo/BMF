//
//  BMFDataStoreSelectionProtocol.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/07/14.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BMFDataStoreSelectionMode) {
    BMFDataStoreSelectionModeSingle,
    BMFDataStoreSelectionModeSinglePerSection,
    BMFDataStoreSelectionModeMultiple,
};

@protocol BMFDataStoreSelectionProtocol <NSObject>

@property (nonatomic, assign) BMFDataStoreSelectionMode mode;

@property (nonatomic, strong) NSArray *selection;

- (void) select:(NSIndexPath *) indexPath;
- (void) deselect:(NSIndexPath *) indexPath;

@end
