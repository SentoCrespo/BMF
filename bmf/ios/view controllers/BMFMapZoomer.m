//
//  BMFMapZoomer.m
//  DataSources
//
//  Created by José Manuel Sánchez on 29/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "BMFMapZoomer.h"

#import "BMF.h"

@implementation BMFMapZoomer {
	double minLat;
	double minLng;
	double maxLat;
	double maxLng;
}

- (id)init
{
    self = [super init];
    if (self) {
		self.zoomPctIncrease = 1.6f;
		self.minimumSpan = 0.005f;
		self.includeOverlays = YES;
    }
    return self;
}

#pragma mark BMFMapZoomerProtocol

/// Perform initial zoom to area of interest
- (void) didLoad:(MKMapView *) mapView {
	if (mapView.annotations.count>0) [self annotationsChanged:mapView];
}

/// Annotations loaded or modified
- (void) annotationsChanged:(MKMapView *) mapView {
	
	if (mapView.annotations.count==0) {
		[self didLoad:mapView];
		return;
	}
	
	// Zoom to all annotations and overlays in map view
	[self p_zoomMapView:mapView annotations:nil overlays:nil animated:NO];
}

/// Overlays loaded or modified
- (void) overlaysChanged:(MKMapView *) mapView {
	[self annotationsChanged:mapView];
}

/// User has tapped a button to show his current location
- (void) userLocationTapped:(MKMapView *) mapView {
	
}

/// User location has updated
- (void) userLocationChanged:(MKMapView *) mapView {
	
}

- (void) zoomMapView:(MKMapView *) mapView annotations: (NSArray *) annotations {
	[self p_zoomMapView:mapView annotations:annotations overlays:nil animated:YES];
}

/// Zooms mapview to show the annotations and overlays passed. Pass nil to include all annotations or overlays
- (void) p_zoomMapView:(MKMapView *) mapView annotations: (NSArray *) annotations overlays:(NSArray *) overlays animated: (BOOL) animated {
	BMFAssertReturn(mapView);
	if (mapView.annotations.count==0 && mapView.overlays.count==0) return;
	
	minLat = DBL_MAX;
	minLng = DBL_MAX;
	maxLat = -DBL_MAX;
	maxLng = -DBL_MAX;
	
	for (id<MKAnnotation> item in mapView.annotations) {
		if (annotations!=nil && ![annotations containsObject:item]) continue;
		
		CLLocationCoordinate2D coord = item.coordinate;
		if (!CLLocationCoordinate2DIsValid(coord)) continue;
		
		if (coord.latitude<minLat) minLat = coord.latitude;
		if (coord.latitude>maxLat) maxLat = coord.latitude;
		if (coord.longitude<minLng) minLng = coord.longitude;
		if (coord.longitude>maxLng) maxLng = coord.longitude;
	}
	
	for (id<MKOverlay> item in mapView.overlays) {
		if (overlays!=nil && ![overlays containsObject:item]) continue;
		
		MKMapRect mapRect = [item boundingMapRect];
		if (MKMapRectIsNull(mapRect)) continue;
		
		CLLocationCoordinate2D minCoord = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMinX(mapRect), MKMapRectGetMinY(mapRect)));
		CLLocationCoordinate2D maxCoord = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)));
		if (!CLLocationCoordinate2DIsValid(minCoord)) continue;
		if (!CLLocationCoordinate2DIsValid(maxCoord)) continue;
		
		if (minCoord.latitude<minLat) minLat = minCoord.latitude;
		if (maxCoord.latitude>maxLat) maxLat = maxCoord.latitude;
		if (minCoord.longitude<minLng) minLng = minCoord.longitude;
		if (maxCoord.longitude>maxLng) maxLng = maxCoord.longitude;
	}
	
	[self mapView:mapView zoomFrom:CLLocationCoordinate2DMake(minLat, minLng) to:CLLocationCoordinate2DMake(maxLat, maxLng) animated:animated];
}

#pragma mark Zoom methods


- (void) mapView:(MKMapView *) mapView zoomFrom: (CLLocationCoordinate2D) min to:(CLLocationCoordinate2D)max animated: (BOOL) animated {
	if (!CLLocationCoordinate2DIsValid(min)) return;
	if (!CLLocationCoordinate2DIsValid(max)) return;
	
	double width = fabs(max.latitude-min.latitude);
	double height = fabs(max.longitude-min.longitude);
	
	if (width<0) width = 0;
	if (height<0) height = 0;
	
	double x = min.latitude+width/2;
	double y = min.longitude+height/2;
	
	if (width>0) width *= self.zoomPctIncrease;
	if (height>0) height *= self.zoomPctIncrease;
	
	CLLocationCoordinate2D location = CLLocationCoordinate2DMake(x, y);
	MKCoordinateSpan span = MKCoordinateSpanMake(width, height);
	
	if (width<self.minimumSpan) span.latitudeDelta = self.minimumSpan;
	if (height<self.minimumSpan) span.longitudeDelta = self.minimumSpan;
	
	BMFLogDebugC(BMFLogUIContext,@"setting map region: %f %f %f %f",location.latitude,location.longitude,span.latitudeDelta,span.longitudeDelta);
	
	MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
	
	[mapView setRegion:region animated:animated];
	
}

@end
