//
//  BMFDisplayAppVersionBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 27/1/15.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFDisplayAppVersionBehavior : BMFViewControllerBehavior

/// The string to format with the version string. By default: Version: %@
@property (nonatomic, copy) IBInspectable NSString *formatString;

@property (nonatomic, weak) IBOutlet UILabel *label;

@end
