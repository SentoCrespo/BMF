//
//  TNMapDataStore.h
//  DataSources
//
//  Created by José Manuel Sánchez on 28/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMFDataSourceProtocol.h"
#import "BMFMapViewDataSource.h"
#import "BMFMapAnnotationFactoryProtocol.h"
#import "BMFMapZoomerProtocol.h"
#import "BMFMapAnnotationCalloutProtocol.h"

#import "BMFDataSource.h"

#import <MapKit/MapKit.h>

@interface BMFMapViewDataSource : BMFDataSource <MKMapViewDelegate, BMFDataSourceProtocol,BMFDataReadProtocol, BMFMapAnnotationCalloutProtocol>

//@property (nonatomic, copy) BMFCompletionBlock dataChangedBlock;

//@property (nonatomic, strong) id<BMFDataReadProtocol> dataStore;
@property (nonatomic, strong) id<BMFDataReadProtocol> overlaysDataStore;
//@property (nonatomic, weak) MKMapView *mapView;

@property (nonatomic, strong) id<BMFMapAnnotationFactoryProtocol> annotationFactory;
@property (nonatomic, strong) id<BMFMapZoomerProtocol> zoomer;

@property (nonatomic, copy) BMFActionBlock calloutButtonTapBlock;

//- (instancetype) initWithDataStore:(id<BMFDataReadProtocol>) dataStore;

@end
