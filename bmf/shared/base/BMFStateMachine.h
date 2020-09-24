//
//  TRNStateMachine.h
//  geofence
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/09/14.
//  Copyright (c) 2014 Treenovum. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString BMFState;

typedef void(^BMFStateChangeBlock)(BMFState *previousState,BMFState *newState);

@interface BMFStateMachine : NSObject

@property (nonatomic, copy) BMFState *currentState;
@property (nonatomic, strong) NSDictionary *validTransitions;

@property (nonatomic, copy) BMFStateChangeBlock willChangeStateBlock;
@property (nonatomic, copy) BMFStateChangeBlock didChangeStateBlock;

- (BOOL) setState:(BMFState *) state;

@end
