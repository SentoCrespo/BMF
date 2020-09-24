//
//  BMFMapAnnotationFactory.h
//  DataSources
//
//  Created by José Manuel Sánchez on 29/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>
#import "BMFMapAnnotation.h"
#import "BMFMapAnnotationFactoryProtocol.h"
#import "BMFMapAnnotationCalloutProtocol.h"

@interface BMFMapAnnotationFactory : NSObject <BMFMapAnnotationFactoryProtocol>

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForUserAnnotation:(id<MKAnnotation>)annotation;
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForMapAnnotation:(id<BMFMapAnnotation>)annotation;

@property (nonatomic, weak) id<BMFMapAnnotationCalloutProtocol> calloutDelegate;

@end
