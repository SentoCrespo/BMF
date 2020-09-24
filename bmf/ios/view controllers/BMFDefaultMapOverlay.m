//
//  BMFDefaultMapOverlay.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/09/14.
//
//

#import "BMFDefaultMapOverlay.h"

#import "BMFMapUtils.h"

@implementation BMFDefaultMapOverlay

- (void) setAnnotations:(NSArray *)annotations {
	_annotations = annotations;
}

#pragma mark BMFMapOverlay


- (CLLocationCoordinate2D) coordinate {
	MKMapRect mapRect  = [self boundingMapRect];
	return CLLocationCoordinate2DMake(MKMapRectGetMidX(mapRect), MKMapRectGetMidY(mapRect));
}

- (MKMapRect) boundingMapRect {
	if (self.annotations.count==0) return MKMapRectNull;
	
	return [BMFMapUtils boundingMapRect:self.annotations];
}


- (MKOverlayRenderer *) renderer {
	if (self.annotations.count==0) return nil;
	
	CLLocationCoordinate2D *coordinates = [self coordinates];
	
	MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:self.annotations.count];
	
	free(coordinates);
	
	MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
	
	renderer.strokeColor = [UIColor redColor];
	renderer.lineWidth = 1;

	if (self.configureRendererBlock) self.configureRendererBlock(renderer);
	
	return renderer;
}

- (CLLocationCoordinate2D *) coordinates {
 
	CLLocationCoordinate2D *coordinates = malloc(sizeof(CLLocationCoordinate2D) * self.annotations.count);
	
	int i = 0;
	for (id<BMFMapAnnotation> annotation in self.annotations) {
		coordinates[i] = annotation.coordinate;
		i++;
	}
	
	return coordinates;
}

@end
