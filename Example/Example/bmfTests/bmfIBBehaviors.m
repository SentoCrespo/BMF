//
//  bmfIBBehaviors.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 6/2/15.
//  Copyright (c) 2015 José Manuel Sánchez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import <BMF/BMFViewController.h>
#import <BMF/BMFAppearTriggerBehavior.h>
#import <BMF/BMFDisappearTriggerBehavior.h>
#import <BMF/BMFAlphaAnimationBehavior.h>
#import <BMF/BMFConstraintAnimationBehavior.h>

SpecBegin(IBBehaviors)

describe(@"Appear Behavior", ^{
	
	it(@"should trigger forward before appear", ^{
		id vc = OCMClassMock([BMFViewController class]);
		BMFAppearTriggerBehavior *appearBehavior = [BMFAppearTriggerBehavior new];
		appearBehavior.owner = vc;
		
		expect(appearBehavior.enabled).to.beTruthy;
		appearBehavior.triggerForward = YES;
		appearBehavior.beforeAppear = YES;

		[vc setNavigationDirection:BMFViewControllerNavigationDirectionForward];
		
		OCMVerify([appearBehavior sendActionsForControlEvents:UIControlEventValueChanged]);
		
		[appearBehavior viewWillAppear:YES];
		
		appearBehavior.triggerForward = NO;
		
		OCMStub([appearBehavior sendActionsForControlEvents:UIControlEventValueChanged]).andDo(^(NSInvocation *invocation) {
			expect(0).to.equal(1);
		});

		[appearBehavior viewWillAppear:YES];
	});
	
	it(@"should trigger forward after appear", ^{
		id vc = OCMClassMock([BMFViewController class]);
		BMFAppearTriggerBehavior *appearBehavior = [BMFAppearTriggerBehavior new];
		appearBehavior.owner = vc;
		
		expect(appearBehavior.enabled).to.beTruthy;
		appearBehavior.triggerForward = YES;
		appearBehavior.beforeAppear = NO;
		
		[vc setNavigationDirection:BMFViewControllerNavigationDirectionForward];
		
		OCMVerify([appearBehavior sendActionsForControlEvents:UIControlEventValueChanged]);
		
		[appearBehavior viewDidAppear:YES];
		
		appearBehavior.triggerForward = NO;
		
		OCMStub([appearBehavior sendActionsForControlEvents:UIControlEventValueChanged]).andDo(^(NSInvocation *invocation) {
			expect(0).to.equal(1);
		});
		
		[appearBehavior viewDidAppear:YES];
	});
	
	it(@"should trigger backward before appear", ^{
		id vc = OCMClassMock([BMFViewController class]);
		BMFAppearTriggerBehavior *appearBehavior = [BMFAppearTriggerBehavior new];
		appearBehavior.owner = vc;
		
		expect(appearBehavior.enabled).to.beTruthy;
		appearBehavior.triggerForward = NO;
		appearBehavior.beforeAppear = YES;
		
		[vc setNavigationDirection:BMFViewControllerNavigationDirectionBackward];
		
		OCMVerify([appearBehavior sendActionsForControlEvents:UIControlEventValueChanged]);
		
		[appearBehavior viewWillAppear:YES];
		
		appearBehavior.triggerForward = NO;
		
		OCMStub([appearBehavior sendActionsForControlEvents:UIControlEventValueChanged]).andDo(^(NSInvocation *invocation) {
			expect(0).to.equal(1);
		});
		
		[appearBehavior viewWillAppear:YES];
	});
	
	it(@"should trigger backward after appear", ^{
		id vc = OCMClassMock([BMFViewController class]);
		BMFAppearTriggerBehavior *appearBehavior = [BMFAppearTriggerBehavior new];
		appearBehavior.owner = vc;
		
		expect(appearBehavior.enabled).to.beTruthy;
		appearBehavior.triggerForward = NO;
		appearBehavior.beforeAppear = NO;
		
		[vc setNavigationDirection:BMFViewControllerNavigationDirectionBackward];
		
		OCMVerify([appearBehavior sendActionsForControlEvents:UIControlEventValueChanged]);
		
		[appearBehavior viewDidAppear:YES];
		
		appearBehavior.triggerForward = NO;
		
		OCMStub([appearBehavior sendActionsForControlEvents:UIControlEventValueChanged]).andDo(^(NSInvocation *invocation) {
			expect(0).to.equal(1);
		});
		
		[appearBehavior viewDidAppear:YES];
	});

	
	it(@"shouldn't trigger with different direction", ^{
		id vc = OCMClassMock([BMFViewController class]);
		BMFAppearTriggerBehavior *appearBehavior = [BMFAppearTriggerBehavior new];
		appearBehavior.owner = vc;
		
		expect(appearBehavior.enabled).to.beTruthy;
		appearBehavior.triggerForward = YES;
		appearBehavior.beforeAppear = YES;
		
		[vc setNavigationDirection:BMFViewControllerNavigationDirectionBackward];
		
		OCMStub([appearBehavior sendActionsForControlEvents:UIControlEventValueChanged]).andDo(^(NSInvocation *invocation) {
			expect(0).to.equal(1);
		});
		
		[appearBehavior viewWillAppear:YES];
		
		OCMStub([appearBehavior sendActionsForControlEvents:UIControlEventValueChanged]).andDo(^(NSInvocation *invocation) {
			expect(0).to.equal(1);
		});
		
		appearBehavior.beforeAppear = NO;
		
		[appearBehavior viewDidAppear:YES];
	});
});

describe(@"Disappear Behavior", ^{
	
	it(@"should trigger forward before disappear", ^{
		id vc = OCMClassMock([BMFViewController class]);
		BMFDisappearTriggerBehavior *disappearBehavior = [BMFDisappearTriggerBehavior new];
		disappearBehavior.owner = vc;
		
		expect(disappearBehavior.enabled).to.beTruthy;
		disappearBehavior.triggerForward = YES;
		disappearBehavior.beforeDisappear = YES;
		
		[vc setNavigationDirection:BMFViewControllerNavigationDirectionForward];
		
		OCMVerify([disappearBehavior sendActionsForControlEvents:UIControlEventValueChanged]);
		
		[disappearBehavior viewWillDisappear:YES];
		
		disappearBehavior.triggerForward = NO;
		
		OCMStub([disappearBehavior sendActionsForControlEvents:UIControlEventValueChanged]).andDo(^(NSInvocation *invocation) {
			expect(0).to.equal(1);
		});
		
		[disappearBehavior viewWillDisappear:YES];
	});
	
	it(@"should trigger forward after disappear", ^{
		id vc = OCMClassMock([BMFViewController class]);
		BMFDisappearTriggerBehavior *disappearBehavior = [BMFDisappearTriggerBehavior new];
		disappearBehavior.owner = vc;
		
		expect(disappearBehavior.enabled).to.beTruthy;
		disappearBehavior.triggerForward = YES;
		disappearBehavior.beforeDisappear = NO;
		
		[vc setNavigationDirection:BMFViewControllerNavigationDirectionForward];
		
		OCMVerify([disappearBehavior sendActionsForControlEvents:UIControlEventValueChanged]);
		
		[disappearBehavior viewDidDisappear:YES];
		
		disappearBehavior.triggerForward = NO;
		
		OCMStub([disappearBehavior sendActionsForControlEvents:UIControlEventValueChanged]).andDo(^(NSInvocation *invocation) {
			expect(0).to.equal(1);
		});
		
		[disappearBehavior viewDidDisappear:YES];
	});
	
	it(@"should trigger backward before disappear", ^{
		id vc = OCMClassMock([BMFViewController class]);
		BMFDisappearTriggerBehavior *disappearBehavior = [BMFDisappearTriggerBehavior new];
		disappearBehavior.owner = vc;
		
		expect(disappearBehavior.enabled).to.beTruthy;
		disappearBehavior.triggerForward = NO;
		disappearBehavior.beforeDisappear = YES;
		
		[vc setNavigationDirection:BMFViewControllerNavigationDirectionBackward];
		
		OCMVerify([disappearBehavior sendActionsForControlEvents:UIControlEventValueChanged]);
		
		[disappearBehavior viewWillDisappear:YES];
		
		disappearBehavior.triggerForward = NO;
		
		OCMStub([disappearBehavior sendActionsForControlEvents:UIControlEventValueChanged]).andDo(^(NSInvocation *invocation) {
			expect(0).to.equal(1);
		});
		
		[disappearBehavior viewWillDisappear:YES];
	});
	
	it(@"should trigger backward after disappear", ^{
		id vc = OCMClassMock([BMFViewController class]);
		BMFDisappearTriggerBehavior *disappearBehavior = [BMFDisappearTriggerBehavior new];
		disappearBehavior.owner = vc;
		
		expect(disappearBehavior.enabled).to.beTruthy;
		disappearBehavior.triggerForward = NO;
		disappearBehavior.beforeDisappear = NO;
		
		[vc setNavigationDirection:BMFViewControllerNavigationDirectionBackward];
		
		OCMVerify([disappearBehavior sendActionsForControlEvents:UIControlEventValueChanged]);
		
		[disappearBehavior viewDidDisappear:YES];
		
		disappearBehavior.triggerForward = NO;
		
		OCMStub([disappearBehavior sendActionsForControlEvents:UIControlEventValueChanged]).andDo(^(NSInvocation *invocation) {
			expect(0).to.equal(1);
		});
		
		[disappearBehavior viewDidDisappear:YES];
	});
	
	
	it(@"shouldn't trigger with different direction", ^{
		id vc = OCMClassMock([BMFViewController class]);
		BMFDisappearTriggerBehavior *disappearBehavior = [BMFDisappearTriggerBehavior new];
		disappearBehavior.owner = vc;
		
		expect(disappearBehavior.enabled).to.beTruthy;
		disappearBehavior.triggerForward = YES;
		disappearBehavior.beforeDisappear = YES;
		
		[vc setNavigationDirection:BMFViewControllerNavigationDirectionBackward];
		
		OCMStub([disappearBehavior sendActionsForControlEvents:UIControlEventValueChanged]).andDo(^(NSInvocation *invocation) {
			expect(0).to.equal(1);
		});
		
		[disappearBehavior viewWillDisappear:YES];
		
		OCMStub([disappearBehavior sendActionsForControlEvents:UIControlEventValueChanged]).andDo(^(NSInvocation *invocation) {
			expect(0).to.equal(1);
		});
		
		disappearBehavior.beforeDisappear = NO;
		
		[disappearBehavior viewDidDisappear:YES];
	});
});

describe(@"Alpha Animation Behavior", ^{
	it(@"should change the view alpha property", ^{
		id vc = OCMClassMock([BMFViewController class]);
		BMFAlphaAnimationBehavior *animationBehavior = [BMFAlphaAnimationBehavior new];
		animationBehavior.owner = vc;
		
		UIView *view = [UIView new];
		view.alpha = 0;
		animationBehavior.views = @[ view ];
		animationBehavior.initialValue = 0;
		animationBehavior.finalValue = 1;
		animationBehavior.duration = 0;
		
		expect(view.alpha).to.equal(0.0);
		
		[animationBehavior runAnimation:self];
		
		expect(view.alpha).after(0.1).to.equal(1.0);
	});
});

describe(@"Constraint Animation Behavior", ^{
	it(@"should change the constant property", ^{
		id vc = OCMClassMock([BMFViewController class]);
		BMFConstraintAnimationBehavior *animationBehavior = [BMFConstraintAnimationBehavior new];
		animationBehavior.owner = vc;
		
		
		NSLayoutConstraint *constraint = [[NSLayoutConstraint alloc] init];
		constraint.constant = 20;
		
		animationBehavior.constraint = constraint;
		animationBehavior.initialValue = 0;
		animationBehavior.finalValue = 1;
		animationBehavior.duration = 0;
		
		expect(constraint.constant).to.equal(20.0);
		
		[animationBehavior runAnimation:self];
		
		expect(constraint.constant).after(0.1).to.equal(1.0);
	});
});

SpecEnd
