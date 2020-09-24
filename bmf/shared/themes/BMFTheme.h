//
//  BMFThemeBase.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/06/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFThemeProtocol.h"

@interface BMFTheme : NSObject <BMFThemeProtocol>

- (NSString *) name;

- (void) setupInitialAppearance;
- (void) setupView:(id) view;

@end
