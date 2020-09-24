//
//  BMFMapUtils.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/09/14.
//
//

#import "BMFMapUtils.h"

@implementation BMFMapUtils

+ (MKMapRect) boundingMapRect:(NSArray *) annotations {
	MKCoordinateRegion region = [self boundingMapRegion:annotations];
	return [self mapRectForCoordinateRegion:region];
}

+ (MKCoordinateRegion) boundingMapRegion:(NSArray *) annotations {
	double minLat = DBL_MAX;
	double minLng = DBL_MAX;
	double maxLat = -DBL_MAX;
	double maxLng = -DBL_MAX;
	
	for (id<MKAnnotation> item in annotations) {
		
		CLLocationCoordinate2D coord = item.coordinate;
		
		if (coord.latitude<minLat) minLat = coord.latitude;
		if (coord.latitude>maxLat) maxLat = coord.latitude;
		if (coord.longitude<minLng) minLng = coord.longitude;
		if (coord.longitude>maxLng) maxLng = coord.longitude;
	}
	
	return [self coordinateRrgionWithMinCoordinate:CLLocationCoordinate2DMake(minLat, minLng) maxCoordinate:CLLocationCoordinate2DMake(maxLat, maxLng)];
}

+ (MKCoordinateRegion) coordinateRrgionWithMinCoordinate:(CLLocationCoordinate2D)minCoordinate maxCoordinate:(CLLocationCoordinate2D) maxCoordinate {
	
	CLLocationCoordinate2D center = CLLocationCoordinate2DMake((maxCoordinate.latitude+minCoordinate.latitude)/2, (maxCoordinate.longitude+minCoordinate.longitude)/2);
	
	MKCoordinateSpan span = MKCoordinateSpanMake(maxCoordinate.latitude-minCoordinate.latitude, maxCoordinate.longitude-minCoordinate.longitude);
	
	return MKCoordinateRegionMake(center, span);
}

+ (MKMapRect) mapRectForCoordinateRegion:(MKCoordinateRegion) region {
	
	MKMapPoint a = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
																	  region.center.latitude + region.span.latitudeDelta / 2,
																	  region.center.longitude - region.span.longitudeDelta / 2));
	MKMapPoint b = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
																	  region.center.latitude - region.span.latitudeDelta / 2,
																	  region.center.longitude + region.span.longitudeDelta / 2));
	
	return MKMapRectMake(MIN(a.x,b.x), MIN(a.y,b.y), ABS(a.x-b.x), ABS(a.y-b.y));
}

@end
