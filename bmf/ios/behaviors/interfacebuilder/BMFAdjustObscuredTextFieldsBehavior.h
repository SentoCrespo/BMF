//
//  BMFAdjustObscuredTextFieldsBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/07/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFViewControllerBehavior.h"

/// Moves the view of the view controller so that the keyboard when appearing doesn't obscure the current textfield
@interface BMFAdjustObscuredTextFieldsBehavior : BMFViewControllerBehavior

/// Can be used for text fields and text views
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *textFields;

@end
