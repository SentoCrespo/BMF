//
//  BMFDefaultMapOverlay.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/09/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFMapOverlay.h"
#import "BMFMapAnnotation.h"

typedef void(^BMFOverlayRendererBlock)(MKOverlayRenderer *renderer);

/// this displays a polyline from the first passed annotation to the last one
@interface BMFDefaultMapOverlay : NSObject <BMFMapOverlay>

@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, copy) BMFOverlayRendererBlock configureRendererBlock;

@end
