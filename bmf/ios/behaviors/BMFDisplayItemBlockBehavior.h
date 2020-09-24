//
//  BMFDisplayItemBlockBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/1/15.
//
//

#import <UIKit/UIKit.h>

#import "BMFDisplayItemBehavior.h"

@interface BMFDisplayItemBlockBehavior : BMFDisplayItemBehavior

@property (nonatomic, copy) BMFItemActionBlock willDisplayBlock;
@property (nonatomic, copy) BMFItemActionBlock didDisplayBlock;

@end
