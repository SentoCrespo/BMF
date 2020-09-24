//
//  BMFUpdateCollectionViewBehavior.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFUpdateCollectionViewBehavior.h"

#import "BMFTypes.h"

@implementation BMFUpdateCollectionViewBehavior {
	id appActiveObserver;
}

- (void) viewWillAppear:(BOOL)animated {
	if (!self.enabled) return;
	
	// Update layout without animation
	[self updateLayoutAnimated:NO];
}

- (void) viewDidAppear:(BOOL)animated {
	if (!self.enabled) return;
	
	appActiveObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
		[self updateLayoutAnimated:NO];
	}];
}

- (void) viewDidDisappear:(BOOL)animated {
	[self stopObserving];
}

- (void) dealloc {
	[self stopObserving];
}

- (void) stopObserving {
	if (appActiveObserver) {
		[[NSNotificationCenter defaultCenter] removeObserver:appActiveObserver], appActiveObserver = nil;
	}
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self updateLayoutAnimated:YES];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	if (!self.enabled) return;
	
	[coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext>context){
		[self updateLayoutAnimated:YES];
	} completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
	
	}];
}

- (void) updateLayoutAnimated:(BOOL) animated {
	if (!self.enabled) return;
	BMFAssertReturn(self.collectionView);

	[self.collectionView.collectionViewLayout invalidateLayout];

}

@end
