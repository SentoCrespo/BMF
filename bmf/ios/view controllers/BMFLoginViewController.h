//
//  BMFLoginViewController.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/07/14.
//
//

#import "BMFViewController.h"

#import "BMFTaskProtocol.h"

@interface BMFLoginViewController : BMFViewController

@property (nonatomic, weak) IBOutlet UITextField *userField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;


- (RACSignal *) buttonEnabledSignal;

- (id<BMFTaskProtocol>) loginTask:(NSString *)user password:(NSString *) password;
- (void) loginTaskFinished:(id) result error:(NSError *) error;

/// Optionally set here the default user/password
- (void) fillDefaultValues;

- (IBAction) login:(id) sender;

@end
