//
//  BMFShowScrollPageBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/1/15.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFShowScrollPageBehavior : BMFViewControllerBehavior

@property (nonatomic, assign) IBInspectable BOOL animated;

@property (nonatomic, assign) IBInspectable NSUInteger pageNumber;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

- (IBAction) showPage:(id) sender;

@end
