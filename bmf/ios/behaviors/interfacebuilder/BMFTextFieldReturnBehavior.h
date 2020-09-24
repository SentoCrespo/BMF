//
//  BMFTextFieldReturnBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 28/1/15.
//
//

#import "BMFViewControllerBehavior.h"

#import "BMFTypes.h"

@interface BMFTextFieldReturnBehavior : BMFViewControllerBehavior

/// If it should stop the edition on return
@property (nonatomic, assign) IBInspectable BOOL stopEditingOnReturn;

@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *textFields;

/// Optional. You can just use the Event value changed if you want
@property (nonatomic, copy) BMFActionBlock textFieldReturnBlock;

@end
