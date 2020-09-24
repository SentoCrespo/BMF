//
//  BMFCollectionReusableView.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 09/09/14.
//
//

#import <UIKit/UIKit.h>

@interface BMFCollectionReusableView : UICollectionReusableView

/// Template method
- (void) performInit __attribute((objc_requires_super));

@end
