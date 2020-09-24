//
//  BMFMapUtils.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/09/14.
//
//

#import <Foundation/Foundation.h>

@import MapKit;

@interface BMFMapUtils : NSObject

+ (MKMapRect) boundingMapRect:(NSArray *) annotations;
+ (MKCoordinateRegion) boundingMapRegion:(NSArray *) annotations;
+ (MKCoordinateRegion) coordinateRrgionWithMinCoordinate:(CLLocationCoordinate2D)minCoordinate maxCoordinate:(CLLocationCoordinate2D) maxCoordinate;
+ (MKMapRect) mapRectForCoordinateRegion:(MKCoordinateRegion) region;

@end
