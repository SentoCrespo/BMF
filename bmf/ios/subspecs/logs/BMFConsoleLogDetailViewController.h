//
//  BMFConsoleLogDetailViewController.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/09/14.
//
//

#import "BMFViewController.h"

#import "BMF.h"

@interface BMFConsoleLogDetailViewController : BMFViewController <BMFObjectControllerProtocol>

@property (nonatomic, strong) BMFObjectDataStore *objectStore;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *logLevelLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *contextLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *dateLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *textView;

@end
