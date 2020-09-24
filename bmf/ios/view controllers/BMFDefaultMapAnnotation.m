//
//  BMFDefaultMapAnnotation.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/09/14.
//
//

#import "BMFDefaultMapAnnotation.h"

@import MapKit;

@implementation BMFDefaultMapAnnotation

- (instancetype)init {
	self = [super init];
	if (self) {
		_canShowCallout = YES;
		_pinColor = MKPinAnnotationColorGreen;
	}
	return self;
}

- (id<MKOverlay>) p_mapOverlay {
	return [MKCircle circleWithCenterCoordinate:self.coordinate radius:10];
}

- (MKOverlayRenderer *) renderer {
	MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:[self p_mapOverlay]];
	
	renderer.strokeColor = [UIColor purpleColor];
	renderer.lineWidth = 1;
	
	return renderer;
}
@end
