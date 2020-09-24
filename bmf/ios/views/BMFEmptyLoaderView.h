//
//  BMFEmptyLoaderView.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 22/1/15.
//
//

#import "BMFView.h"

#import "BMFLoaderViewProtocol.h"

@interface BMFEmptyLoaderView : BMFView <BMFLoaderViewProtocol>

@property (nonatomic, strong) NSString *message;

@property (nonatomic, copy) BMFActionBlock reloadActionBlock;
@property (nonatomic, strong) BMFProgress *progress;

- (void) addToViewController:(UIViewController *) vc;

@end
