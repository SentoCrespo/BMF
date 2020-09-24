//
//  BMFConsoleLogTableViewCellConfigurator.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/09/14.
//
//

#import "BMFConsoleLogTableViewCellConfigurator.h"

#import "BMF.h"

#import "BMFConsoleLogUtils.h"

#import "BMFConsoleLogTableViewCell.h"

#import <JMSLogger/JMSLogMessage.h>

@implementation BMFConsoleLogTableViewCellConfigurator

+ (void) load {
	[self register];
}

+ (Class) itemClass {
	return [JMSLogMessage class];
}

+ (Class) viewClass {
	return [BMFConsoleLogTableViewCell class];
}

+ (void) configure:(BMFConsoleLogTableViewCell *)view kind:(NSString *)kind withItem:(JMSLogMessage *)item inView:(UIView *)containerView atIndexPath:(NSIndexPath *)indexPath controller:(id)controller {
	
	view.messageLabel.textColor = [BMFConsoleLogUtils colorForLogLevel:item.logLevel];

	view.messageLabel.text = item.text;
	view.contextLabel.text = [BMFConsoleLogUtils contextStringForContext:item.context];
}

@end
