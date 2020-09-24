//
//  BMFCollectionViewZoomSelectedCellBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/07/14.
//
//

#import "BMFCollectionViewZoomSelectedCellBehavior.h"

#import "BMFDataSourceProtocol.h"
#import "BMF.h"

@interface BMFCollectionViewZoomSelectedCellBehavior()

@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, weak) UIView *oldCell;
@property (nonatomic, assign) CGAffineTransform oldTransform;

@end

@implementation BMFCollectionViewZoomSelectedCellBehavior

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.objectStore = [BMFObjectDataStore new];
    }
    return self;
}

#pragma mark Actions

- (IBAction)stopZooming:(id)sender {
	[self stopZooming:self.oldCell containerView:self.view];
}

#pragma mark UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.enabled) return;
	if (collectionView!=self.view) return;

	if (cell==self.oldCell) {
		[self.objectStore setCurrentValue:nil];
		self.oldCell = nil;
	}
}

- (void) itemTapped:(id) item atIndexPath:(NSIndexPath *) indexPath containerView:(UICollectionView *)containerView {
	if (!self.enabled) return;
	if (containerView!=self.view) return;

	BMFAssertReturn([containerView isKindOfClass:[UICollectionView class]]);
	
	UICollectionView *collectionView = containerView;
	
	UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	if (self.objectStore.currentValue==item && !CGAffineTransformEqualToTransform(cell.transform, CGAffineTransformIdentity)) {
		[self stopZooming:cell containerView:containerView];
	}
	else {
		[self stopZooming:self.oldCell containerView:containerView];
		self.objectStore.currentValue = item;
		[self startZooming:cell containerView:containerView];
		self.oldCell = cell;
	}
}

- (void) startZooming:(UIView *) view containerView:(UICollectionView *) containerView {
	self.oldFrame = view.frame;

	[containerView bringSubviewToFront:view];
	view.frame = self.oldFrame;
	
	[UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{

		CGRect finalRect = [BMFUtils rectToFitRect:view.frame toRect:containerView.bounds mode:BMFContentModeScaleAspectFit];
		CGAffineTransform t = CGAffineTransformIdentity;
		CGPoint containerCenter = CGPointMake(containerView.contentOffset.x+containerView.bounds.size.width/2,containerView.contentOffset.y+containerView.bounds.size.height/2);
		
		CGPoint viewCenter = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame));
		
		t = CGAffineTransformTranslate(t,-(viewCenter.x-containerCenter.x),-(viewCenter.y-containerCenter.y));

		
		t = CGAffineTransformScale(t,finalRect.size.width/view.frame.size.width, finalRect.size.height/view.frame.size.height);

		view.transform = t;
		self.oldTransform = t;
	} completion:^(BOOL finished) {
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}];	
}

- (void) stopZooming:(UIView *) view containerView:(UIView *) containerView {
	[self.objectStore setCurrentValue:nil];
	[UIView animateWithDuration:0.5 animations:^{
		view.transform = CGAffineTransformIdentity;
	} completion:^(BOOL finished) {
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}];
}

@end
