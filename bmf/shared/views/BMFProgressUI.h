//
//  BMFProgressUI.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 02/06/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFLoaderViewProtocol.h"

@interface BMFProgressUI : NSObject <BMFLoaderViewProtocol>

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) BMFProgress *progress;

@property (nonatomic, copy) BMFActionBlock reloadActionBlock;


- (CGFloat) displayedProgressWithFractionCompleted:(CGFloat) fractionCompleted;

/// Template method to be implemented by subclasses to update the view
- (void) updateRunning: (BOOL) running;

/// Template method to be implemented by subclasses to update the view
- (void) updateProgress:(CGFloat) progress;

@end
