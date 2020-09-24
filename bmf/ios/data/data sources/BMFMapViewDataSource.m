//
//  TNMapDataStore.m
//  DataSources
//
//  Created by José Manuel Sánchez on 28/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFMapViewDataSource.h"

#import "BMFMapAnnotation.h"
#import "BMFMapOverlay.h"
#import "BMFMapZoomer.h"
#import "BMFMapAnnotationFactory.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation BMFMapViewDataSource {
	id dataDidChangeObservationToken;
	id dataBatchChangeObservationToken;
	id overlayDataDidChangeObservationToken;
	id overlayDataBatchChangeObservationToken;
}

- (instancetype) initWithDataStore:(id<BMFDataReadProtocol>) dataStore {
    self = [super initWithDataStore:dataStore];
    if (self) {
		
		[self loadItems];
		
		[self observeDataChanges];
		
		__weak BMFMapViewDataSource *wself =self;
		
		_zoomer = [BMFMapZoomer new];
		_annotationFactory = [BMFMapAnnotationFactory new];
		[_annotationFactory setCalloutDelegate:self];

		[RACObserve(self, dataStore) subscribeNext:^(id x) {
			[wself loadItems];
			[wself observeDataChanges];
		}];

		[RACObserve(self, overlaysDataStore) subscribeNext:^(id x) {
			[wself loadItems];
			[wself observeDataChanges];
		}];
    }
    return self;
}

- (void) dealloc {
	self.dataStore = nil;
	[self stopObserving];
}

- (void) setView:(BMFIXView *)view {
	BMFAssertReturn(!view || [view isKindOfClass:[MKMapView class]]);
	
	[super setView:view];
	
	[self.zoomer didLoad:(id)self.view];
	
	[self loadItems];
}

- (void) observeDataChanges {
	[self stopObserving];
	
	dataDidChangeObservationToken = [[NSNotificationCenter defaultCenter] addObserverForName:BMFDataDidChangeNotification object:self.dataStore queue:nil usingBlock:^(NSNotification *note) {
		[self loadItems];
	}];

	dataBatchChangeObservationToken = [[NSNotificationCenter defaultCenter] addObserverForName:BMFDataBatchChangeNotification object:self.dataStore queue:nil usingBlock:^(NSNotification *note) {
		[self loadItems];
	}];

	overlayDataDidChangeObservationToken = [[NSNotificationCenter defaultCenter] addObserverForName:BMFDataDidChangeNotification object:_overlaysDataStore queue:nil usingBlock:^(NSNotification *note) {
		[self loadItems];
	}];
	
	overlayDataBatchChangeObservationToken = [[NSNotificationCenter defaultCenter] addObserverForName:BMFDataBatchChangeNotification object:_overlaysDataStore queue:nil usingBlock:^(NSNotification *note) {
		[self loadItems];
	}];

}

- (void) stopObserving {
	if (dataDidChangeObservationToken) [[NSNotificationCenter defaultCenter] removeObserver:dataDidChangeObservationToken];
	if (dataBatchChangeObservationToken) [[NSNotificationCenter defaultCenter] removeObserver:dataBatchChangeObservationToken];
	if (overlayDataDidChangeObservationToken) [[NSNotificationCenter defaultCenter] removeObserver:overlayDataDidChangeObservationToken];
	if (overlayDataBatchChangeObservationToken) [[NSNotificationCenter defaultCenter] removeObserver:overlayDataBatchChangeObservationToken];
}

- (void) loadItems {
	
	if (!self.view) return;
	
	if ([self.dataStore.allItems count]==0) return;
	
	MKMapView *mapView = [MKMapView BMF_cast:self.view];
	
	[mapView removeAnnotations:mapView.annotations];
	[mapView removeOverlays:mapView.overlays];
		
	[mapView addAnnotations:[self.dataStore allItems]];
	[mapView addOverlays:[self.overlaysDataStore allItems]];
	
	[self.zoomer annotationsChanged:mapView];
	
	if (self.dataChangedBlock) self.dataChangedBlock(self.dataStore.allItems,nil);
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
	
	BMFAssertReturnNil(self.view);
	
	MKAnnotationView *view = nil;
	
	id<BMFMapAnnotation> mapAnnotation = nil;
	
	if (annotation==mapView.userLocation) {
		view = [self.annotationFactory mapView:mapView viewForUserAnnotation:annotation];
	}
	else if ([annotation conformsToProtocol:@protocol(BMFMapAnnotation)]) {
		mapAnnotation = (id<BMFMapAnnotation>)annotation;
		view = [self.annotationFactory mapView:mapView viewForMapAnnotation:mapAnnotation];
	}
	
	if (self.didConfigureViewBlock) self.didConfigureViewBlock(view);
	
	return view;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
	
	if (![overlay conformsToProtocol:@protocol(BMFMapOverlay)]) {
		[NSException raise:@"Overlay doesn't conform to protocol BMFMapOverlay" format:@"%@",overlay];
		return nil;
	}
	
	id<BMFMapOverlay> mapOverlay = (id<BMFMapOverlay>)overlay;
	return [mapOverlay renderer];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	[self.zoomer userLocationChanged:(id)self.view];
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	if (self.calloutButtonTapBlock) self.calloutButtonTapBlock(view);
}

#pragma mark BMFDataReadProtocol

- (NSInteger) numberOfSections {
	return [self.dataStore numberOfSections];
}

- (NSInteger) numberOfRowsInSection:(NSUInteger) section {
	return [self.dataStore numberOfRowsInSection:section];
}

- (id) itemAt:(NSInteger) section row:(NSInteger) row {
	return [self.dataStore itemAt:section row:row];
}

- (NSArray *) allItems {
	return [self.dataStore allItems];
}

#pragma mark BMFMapAnnotationCalloutProtocol

- (UIView *) leftCalloutAccessoryView {
	return nil;
}

- (UIView *) rightCalloutAccessoryView {
	if (self.calloutButtonTapBlock) {
		return [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	}
	
	return nil;
}

@end
