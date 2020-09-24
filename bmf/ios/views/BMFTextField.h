//
//  BMFTextField.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 2/10/14.
//
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface BMFTextField : UITextField

@property (nonatomic) IBInspectable CGPoint BMF_contentInset;

- (void) performInit __attribute((objc_requires_super));

@end
