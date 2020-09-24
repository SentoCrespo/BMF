//
//  BMFThemeBase.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/06/14.
//
//

#import "BMFTheme.h"

#import "BMF.h"

static NSMutableArray *registeredList = nil;

@implementation BMFTheme

- (BMFIXColor *) tintColor {
	BMFAbstractMethod();
	return nil;
}

- (NSString *) name {
	return @"default";
}

- (void) setupInitialAppearance {
#if TARGET_OS_IPHONE
	[[UIApplication sharedApplication] keyWindow].tintColor = self.tintColor;
#endif
}

- (void) setupView:(id) view {
	BMFAbstractMethod();
}

@end
