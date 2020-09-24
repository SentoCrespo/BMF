//
//  BMFMapViewController.m
//  DataSources
//
//  Created by José Manuel Sánchez on 28/10/13.
//  Copyright (c) 2013 treenovum. All rights reserved.
//

#import "BMFMapViewController.h"

#import "BMFMapAnnotation.h"
#import "BMFMapOverlay.h"
#import "BMFMapZoomer.h"
#import "BMFMapAnnotationFactory.h"

#import "BMFDataReadProtocol.h"

#import "MKMapView+BMF.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface BMFMapViewController ()

@end

@implementation BMFMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	@weakify(self);
	[[[RACObserve(self, dataSource) scanWithStart:nil reduce:^id(id<BMFDataSourceProtocol> running, id next) {
		@strongify(self);
		running.view = nil;
		if (running) [self.BMF_proxy removeDestinationObject:running];
		return next;
	}] filter:^BOOL(id value) {
		return value!=nil;
	}] subscribeNext:^(id x) {
		@strongify(self);
		[self.BMF_proxy addDestinationObject:x];

		self.dataSource.view = self.mapView;
	}];

	RACSignal *mapViewSignal = RACObserve(self, mapView);
	
	RAC(self.dataSource,view) = mapViewSignal;
	
	if (self.mapView) [self.BMF_proxy makeDelegateOf:self.mapView withSelector:@selector(setDelegate:)];
}

- (void) setMapView:(MKMapView *)mapView {
	_mapView = mapView;
	
	if (_mapView) [self.BMF_proxy makeDelegateOf:_mapView withSelector:@selector(setDelegate:)];

}

@end
