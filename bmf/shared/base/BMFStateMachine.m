//
//  TRNStateMachine.m
//  geofence
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/09/14.
//  Copyright (c) 2014 Treenovum. All rights reserved.
//

#import "BMFStateMachine.h"

#import "BMF.h"

@implementation BMFStateMachine

- (BOOL) setState:(BMFState *) state {
	if ([state isEqualToString:self.currentState]) return YES;
	
	BMFState *oldState = self.currentState;
	
	if (![self validateTransitionFromState:oldState toState:state]) return NO;
	
	if (self.willChangeStateBlock) self.willChangeStateBlock(oldState,state);
	
	self.currentState = state;
	
	if (self.didChangeStateBlock) self.didChangeStateBlock(oldState,state);
	
	return YES;
}

- (BOOL) validateTransitionFromState:(BMFState *) oldState toState:(BMFState *) state {
	
	id validTransitions = self.validTransitions[oldState];
	NSArray *validTransitionsArray = [NSArray BMF_cast:validTransitions];
	if (validTransitionsArray) {
		if ([validTransitionsArray containsObject:state]) {
			return YES;
		}
	}
	
	BMFState *validTransitionString = [BMFState BMF_cast:validTransitions];
	if (validTransitionString && [validTransitionString isEqualToString:state]) {
		return YES;
	}
	
	DDLogError(@"Invalid transition from state: %@ to %@",oldState,state);
	
	return NO;
}

@end
