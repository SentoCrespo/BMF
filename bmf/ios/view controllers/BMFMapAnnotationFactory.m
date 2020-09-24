//
//  BMFMapAnnotationFactory.m
//  DataSources
//
//  Created by José Manuel Sánchez on 29/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFMapAnnotationFactory.h"

@implementation BMFMapAnnotationFactory

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForUserAnnotation:(id<MKAnnotation>)annotation {
	return nil;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForMapAnnotation:(id<BMFMapAnnotation>)annotation {
	
	MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:annotation.annotationID];
	if (!view) {
		MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotation.annotationID];
		if ([annotation respondsToSelector:@selector(pinColor)]) pinView.pinColor = annotation.pinColor;
		view = pinView;
	}
	
	view.canShowCallout = annotation.canShowCallout;
	if ([annotation respondsToSelector:@selector(annotationImage)]) {
		UIImage *image = annotation.annotationImage;
		if (image) view.image = image;
	}
	
	if ([annotation respondsToSelector:@selector(annotationBorderWidth)]) view.layer.borderWidth = annotation.annotationBorderWidth;
	if ([annotation respondsToSelector:@selector(annotationBorderColor)]) {
		if (annotation.annotationBorderColor) view.layer.borderColor = annotation.annotationBorderColor.CGColor;
	}
	if ([annotation respondsToSelector:@selector(annotationBackgroundColor)]) {
		if (annotation.annotationBackgroundColor) view.backgroundColor = annotation.annotationBackgroundColor;
	}
	
	if (self.calloutDelegate) {
		view.leftCalloutAccessoryView = [self.calloutDelegate leftCalloutAccessoryView];
		view.rightCalloutAccessoryView = [self.calloutDelegate rightCalloutAccessoryView];
	}
	
	
	return view;
}


@end
