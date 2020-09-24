//
//  BMFLoginViewController.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/07/14.
//
//

#import "BMFLoginViewController.h"

#import <BMF/BMF.h>
#import <BMF/BMFProgress.h>

#import <BMF/BMFResponderChainBehavior.h>
#import <BMF/BMFAdjustObscuredTextFieldsBehavior.h>
#import <BMF/BMFBackgroundTapStopsEditingBehavior.h>

#import <ReactiveCocoa/RACEXTScope.h>

@interface BMFLoginViewController ()

@end

@implementation BMFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	[self fillDefaultValues];
	
	[self recoverLastValues];
	
	RAC(self.loginButton,enabled) = [self buttonEnabledSignal];
	
	[self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
	
	BMFResponderChainBehavior *textFieldsBehavior = [BMFResponderChainBehavior new];
	textFieldsBehavior.responders = @[ self.userField,self.passwordField ];
	textFieldsBehavior.lastResponderReturnKeyType = UIReturnKeySend;
	textFieldsBehavior.lastResponderActionBlock = ^(id sender) {
		[self login:self];
	};
	[self addBehavior:textFieldsBehavior];
	
	BMFAdjustObscuredTextFieldsBehavior *adjustTextFieldsBehavior = [BMFAdjustObscuredTextFieldsBehavior new];
	adjustTextFieldsBehavior.textFields = @[ self.userField, self.passwordField ];
	[self addBehavior:adjustTextFieldsBehavior];
	
	[self addBehavior:[BMFBackgroundTapStopsEditingBehavior new]];
}

- (RACSignal *) buttonEnabledSignal {
	RACSignal *userTextSignal = [self.userField rac_textSignal];
	RACSignal *passTextSignal = [self.passwordField rac_textSignal];

	@weakify(self);
	RACSignal *buttonEnabledSignal = [RACSignal combineLatest:@[ userTextSignal, passTextSignal ] reduce:^(NSString *user,NSString *password){
		@strongify(self);
		return @(user.length>0 && password.length>0 && !self.loaderView.progress.running);
	}];
	return buttonEnabledSignal;
}

- (void) fillDefaultValues {}

- (NSString *) bmf_userKey {
	return [NSString stringWithFormat:@"%@_user",self.restorationIdentifier];
}

- (NSString *) bmf_passKey {
	return [NSString stringWithFormat:@"%@_pass",self.restorationIdentifier];
}


- (void) saveCurrentValues {
	if (self.restorationIdentifier.length==0) {
		BMFLogWarn(@"No restoration identifier set for BMFLoginViewController. Last user entered values will not be saved");
		return;
	}
	
	[[NSUserDefaults standardUserDefaults] setValue:self.userField.text forKey:[self bmf_userKey]];
	[[NSUserDefaults standardUserDefaults] setValue:self.passwordField.text forKey:[self bmf_passKey]];
}

- (void) recoverLastValues {
	if (self.restorationIdentifier.length==0) {
		BMFLogWarn(@"No restoration identifier set for BMFLoginViewController. Last user entered values will not be recovered");
		return;
	}
	
	self.userField.text = [[NSUserDefaults standardUserDefaults] valueForKey:[self bmf_userKey]];
	self.passwordField.text = [[NSUserDefaults standardUserDefaults] valueForKey:[self bmf_passKey]];
}

- (IBAction) login:(id) sender {
	if (self.loaderView.progress.running) return;

	[self saveCurrentValues];
	[self.view endEditing:YES];
	
	id<BMFTaskProtocol> loginTask = [self loginTask:self.userField.text password:self.passwordField.text];
	[self.loaderView.progress addChild:loginTask.progress];
	[self runTask:loginTask completion:^(id result, NSError *error) {
		[self loginTaskFinished:result error:error];
	}];
}


- (id<BMFTaskProtocol>) loginTask:(NSString *)user password:(NSString *) password {
	BMFAbstractMethod();
	return nil;
}

- (void) loginTaskFinished:(id) result error:(NSError *) error {
	BMFAbstractMethod();
}

@end
