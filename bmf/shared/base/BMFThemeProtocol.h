//
//  BMFThemeProtocol.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/06/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"

@protocol BMFThemeProtocol

- (BMFIXColor *) tintColor;

- (NSString *) name;

- (void) setupInitialAppearance;

- (void) setupView:(id) view;

@end
