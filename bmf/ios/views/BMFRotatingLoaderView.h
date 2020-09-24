//
//  BMFRotateImageLoaderView.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 29/1/15.
//
//

#import "BMFView.h"

#import "BMFTypes.h"
#import "BMFLoaderViewProtocol.h"

@interface BMFRotatingLoaderView : BMFView <BMFLoaderViewProtocol>

@property (nonatomic, strong) NSString *message;

@property (nonatomic, copy) BMFActionBlock reloadActionBlock;

@property (nonatomic) IBInspectable CGFloat rotationDuration;

@property (nonatomic, strong) BMFProgress *progress;

- (void) addToViewController:(UIViewController *) vc;

@end
