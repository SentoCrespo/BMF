//
//  BMFDynamicTypeBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/2/15.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFDynamicTypeBehavior : BMFViewControllerBehavior

@property (nonatomic) IBOutletCollection(UIView) NSArray *views;

/// If empty Body will be used. Can be body, headline, subheadline, footnote, caption1, caption2
@property (nonatomic, copy) IBInspectable NSString *fontStyle;

/// If nil the default will be used
@property (nonatomic, copy) IBInspectable NSString *fontFamily;

/// Force the font to be bold
@property (nonatomic) IBInspectable BOOL forceBold;

/// Force the font to be italic
@property (nonatomic) IBInspectable BOOL forceItalic;

/// Increment the pointSize of the font style by this amount
@property (nonatomic) IBInspectable CGFloat pointSizeIncrement;

@end
