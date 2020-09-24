//
//  UITextField+BMF.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 3/10/14.
//
//

#import <UIKit/UIKit.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface UITextField (BMF)

- (RACSignal *)rac_keyboardReturnSignal;

@end
