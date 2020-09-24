//
//  BMFPlayMusicBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/08/14.
//
//

#import "BMFViewControllerBehavior.h"

IB_DESIGNABLE
/// Plays background music while the view controller is visible
@interface BMFPlayMusicBehavior : BMFViewControllerBehavior

@property (nonatomic, strong) IBInspectable NSString *resourceFileName;

/// -1 by default. If negative it plays forever
@property (nonatomic, assign) IBInspectable NSInteger repeatCount;

@property (nonatomic, strong) NSURL *fileUrl;

//- (instancetype) initWithFileUrl:(NSURL *) fileUrl;

- (IBAction) startPlaying:(id) sender;
- (IBAction) stopPlaying:(id) sender;

@end
