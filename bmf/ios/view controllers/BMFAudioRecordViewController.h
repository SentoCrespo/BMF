//
//  BMFAudioRecordViewController.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/08/14.
//
//

#import "BMFViewController.h"

#import "BMFTypes.h"

@interface BMFAudioRecordViewController : BMFViewController

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *micImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *timeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *recordButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, copy) BMFActionBlock cancelBlock;
@property (nonatomic, copy) BMFActionBlock useAudioBlock;

/// The title of the button for using the audio. "Save" by default
@property (nonatomic, copy) NSString *useAudioTitle;

@property (nonatomic, copy) NSURL *fileUrl;

/// If the user cancels this will be YES. If it's false we will have some audio recorded in the fileUrl;
@property (nonatomic, readonly) BOOL cancelled;

- (void) startRecording;
- (void) pauseRecording;
- (void) stopRecording;

- (IBAction) record:(id) sender;
- (IBAction) play:(id)sender;
	
@end
