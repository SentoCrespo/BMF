//
//  BMFContentSizeAspect.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 12/5/15.
//
//

#import "BMFAspect.h"

#import "BMFTypes.h"

@interface BMFContentSizeAspect : BMFAspect

/// This view can be a scroll view, a web view, a table view or a collection view
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;

@property (nonatomic, copy) BMFActionBlock constraintChanged;

- (void) update;

@end
