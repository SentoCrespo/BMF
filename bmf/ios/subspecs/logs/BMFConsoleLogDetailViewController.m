//
//  BMFConsoleLogDetailViewController.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/09/14.
//
//

#import "BMFConsoleLogDetailViewController.h"

#import "BMFObjectClassValidator.h"
#import "BMFConsoleLogUtils.h"

#import <JMSLogger/JMSLogMessage.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface BMFConsoleLogDetailViewController ()

@end

@implementation BMFConsoleLogDetailViewController

- (void) performInit {
	[super performInit];
	
	self.objectStore = [[BMFObjectDataStore alloc] init];
	self.objectStore.acceptValueValidator = [[BMFObjectClassValidator alloc] initWithClass:[JMSLogMessage class]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

	@weakify(self);
	self.objectStore.signalBlock = ^(JMSLogMessage *message) {
		@strongify(self);
		if (message) {
			[self reload];
		}
	};
}

- (void) reload {
	JMSLogMessage *logMessage = self.objectStore.currentValue;

	self.contextLabel.text = [BMFConsoleLogUtils contextStringForContext:logMessage.context];
	self.logLevelLabel.text =[BMFConsoleLogUtils logLevelStringForLogLevel:logMessage.logLevel];
	self.logLevelLabel.textColor = [BMFConsoleLogUtils colorForLogLevel:logMessage.logLevel];
	
	self.textView.text = logMessage.text;
}

@end
