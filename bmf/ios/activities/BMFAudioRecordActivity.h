//
//  BMFAudioRecordActivity.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/08/14.
//
//

#import "BMFActivity.h"

@interface BMFAudioRecordActivity : BMFActivity

/// YES by default. If set to YES the activity will start recording as soon as it's run. If it's NO the user must tap the Record button first
@property (nonatomic, assign) BOOL startImmediately;

/// The title of the button for using the audio. "Save" by default
@property (nonatomic, copy) NSString *useAudioTitle;

@end
