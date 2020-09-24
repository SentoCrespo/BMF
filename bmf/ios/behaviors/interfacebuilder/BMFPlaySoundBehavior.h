//
//  BMFPlaySoundBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 19/11/14.
//
//

#import "BMFViewControllerBehavior.h"

@interface BMFPlaySoundBehavior : BMFViewControllerBehavior

@property (nonatomic, strong) IBInspectable NSString *resourceFileName;

@property (nonatomic, strong) NSURL *fileUrl;

- (IBAction) play:(id) sender;

@end
