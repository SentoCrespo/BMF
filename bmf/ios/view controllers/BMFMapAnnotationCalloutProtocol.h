//
//  BMFMapAnnotationCalloutProtocol.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 16/05/14.
//
//

#import <UIKit/UIKit.h>

@protocol BMFMapAnnotationCalloutProtocol <NSObject>

- (UIView *) leftCalloutAccessoryView;
- (UIView *) rightCalloutAccessoryView;

@end
