//
//  BMFDefaultMapAnnotation.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/09/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFMapAnnotation.h"

@class MKOverlayRenderer;

@interface BMFDefaultMapAnnotation : NSObject <BMFMapAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

// Called as a result of dragging an annotation view.
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate NS_AVAILABLE(10_9, 4_0);

@property(nonatomic, strong) NSString * annotationID;
@property(nonatomic, assign) BOOL canShowCallout;


@property(nonatomic, strong) UIImage * annotationImage;

@property(nonatomic, assign) MKPinAnnotationColor pinColor;

@property(nonatomic, strong) UIColor * annotationBackgroundColor;

@property(nonatomic, assign) CGFloat annotationBorderWidth;
@property(nonatomic, strong) UIColor * annotationBorderColor;

- (MKOverlayRenderer *) renderer;

@end
