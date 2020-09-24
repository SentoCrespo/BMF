//
//  BMFConsoleLogTableViewCell.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/09/14.
//
//

#import "BMFTableViewCell.h"

@interface BMFConsoleLogTableViewCell : BMFTableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *messageLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *contextLabel;

@end
