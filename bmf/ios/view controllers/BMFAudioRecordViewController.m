//
//  BMFAudioRecordViewController.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/08/14.
//
//

#import "BMFAudioRecordViewController.h"

#import "BMF.h"
#import "BMFIXColor+CrossFade.h"

#import <ReactiveCocoa/RACEXTScope.h>
#import "BMFBlockTimerViewControllerBehavior.h"

@import AVFoundation;

@interface BMFAudioRecordViewController () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) NSDate *startRecordDate;
@property (nonatomic, strong) NSDate *stopRecordDate;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation BMFAudioRecordViewController

- (void) performInit {
	[super performInit];
	
	_useAudioTitle = BMFLocalized(@"Save", nil);
	
	NSArray *pathComponents = [NSArray arrayWithObjects:
							   [BMFUtils applicationCacheDirectory],
                               @"BMFAudioRecording.m4a",
                               nil];
    _fileUrl = [NSURL fileURLWithPathComponents:pathComponents];
	
	_formatter = [[NSDateFormatter alloc] init];
	[_formatter setDateFormat:@"mm:ss"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = BMFLocalized(@"Record", nil);
	
	[self.playButton setImage:[[BMFBase sharedInstance] imageNamed:@"play"] forState:UIControlStateNormal];
	[self.recordButton setImage:[[BMFBase sharedInstance] imageNamed:@"record"] forState:UIControlStateNormal];
	
	self.micImageView.image = [[[BMFBase sharedInstance] imageNamed:@"mic"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	self.micImageView.tintColor = [UIColor blackColor];

	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.useAudioTitle style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
	
	@weakify(self);
	
	RACSignal *startRecordDateSignal = RACObserve(self, startRecordDate);
	RACSignal *stopRecordDateSignal = RACObserve(self, stopRecordDate);
	[[RACSignal combineLatest:@[startRecordDateSignal, stopRecordDateSignal]] subscribeNext:^(id x) {
		@strongify(self);
		[self updateDate];
	}];
	
	RACSignal *hasRecorded = [stopRecordDateSignal map:^id(id value) {
		return @(value!=nil);
	}];
	
	RACSignal *recordingSignal = RACObserve(self, recorder.recording);
	RAC(self.playButton,enabled) = [[RACSignal combineLatest:@[ recordingSignal, hasRecorded ]] map:^id(RACTuple *signalValues) {
		return @(![signalValues.first boolValue] && [signalValues.second boolValue]);
	}];
	
	RACSignal *playingSignal = RACObserve(self, player.playing);
	[[RACSignal combineLatest:@[ playingSignal, recordingSignal ]] subscribeNext:^(id x) {
		@strongify(self);
		[self updatePlayState];
	}];
	
	RAC(self.navigationItem.rightBarButtonItem,enabled) = [RACObserve(self, stopRecordDate) map:^id(id value) {
		return @(value!=nil);
	}];
		
	BMFBlockTimerViewControllerBehavior *updateDateBehavior = [[BMFBlockTimerViewControllerBehavior alloc] initWithActionBlock:^(id sender) {
		[self updateDate];
	} interval:1];
	[self addBehavior:updateDateBehavior];
	
	[self prepareRecordingSession];
}

- (void) updateDate {
	NSTimeInterval duration = 0;
	
	if (self.startRecordDate) {
		if (self.stopRecordDate) {
			duration = [self.stopRecordDate timeIntervalSinceDate:self.startRecordDate];
		}
		else {
			duration = [[NSDate date] timeIntervalSinceDate:self.startRecordDate];
		}
	}
	
	NSDate *durationDate = [NSDate dateWithTimeIntervalSinceReferenceDate:duration];
	self.timeLabel.text = [self.formatter stringFromDate:durationDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showRecording {
	CABasicAnimation *theAnimation;
	
	theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
	theAnimation.duration=1.0;
	theAnimation.repeatCount=HUGE_VALF;
	theAnimation.autoreverses=YES;
	theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
	theAnimation.toValue=[NSNumber numberWithFloat:0.5];
	[self.micImageView.layer addAnimation:theAnimation forKey:@"animateOpacity"];
	
	self.micImageView.tintColor = [UIColor redColor];
}

- (void) hideRecording {
	[self.micImageView.layer removeAllAnimations];
	self.micImageView.layer.opacity = 1;
	self.micImageView.tintColor = [UIColor blackColor];
}

#pragma mark Actions

- (void) save:(id) sender {
	if (!self.stopRecordDate) return;
	
	if (self.useAudioBlock) self.useAudioBlock(self.fileUrl);
	
	_cancelled = NO;
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) record:(id) sender {
	if (self.recorder.recording) {
		// Stop recording
		[self stopRecording];
//		self.recordButton.imageView.image =  [[BMFBase sharedInstance] imageNamed:@"record"]; //[[BMFBase sharedInstance] imageNamed:@"record"];
		[self.recordButton setImage:[[BMFBase sharedInstance] imageNamed:@"record"] forState:UIControlStateNormal];
//		[self.recordButton setTitle:BMFLocalized(@"Record", nil) forState:UIControlStateNormal];
	}
	else {
		// Start recording
		[self startRecording];
		[self.recordButton setImage:[[BMFBase sharedInstance] imageNamed:@"stop_record"] forState:UIControlStateNormal];
		
//		self.recordButton.imageView.image = [[BMFBase sharedInstance] imageNamed:@"stop_record"]; //[[BMFBase sharedInstance] imageNamed:@"stop"];
//		[self.recordButton setTitle:BMFLocalized(@"Stop", nil) forState:UIControlStateNormal];
	}
}

- (IBAction)play:(id)sender {
	if (!self.recorder.recording) {
		if (self.player.playing) {
			[self.player stop];
		}
		else {
			self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
			[self.player setDelegate:self];
			[self.player play];
		}
		
		[self updatePlayState];
    }
}

- (void) cancel:(id) sender {
	
	if (self.cancelBlock) self.cancelBlock(self);
	
	_cancelled = YES;
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Recording methods

- (void) prepareRecordingSession {
	
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
	
	NSDictionary *recordSettings = @{ AVFormatIDKey : @(kAudioFormatMPEG4AAC),
									  AVSampleRateKey : @44100.0,
									  AVNumberOfChannelsKey: @2 };
	
    // Initiate and prepare the recorder
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.fileUrl settings:recordSettings error:NULL];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
	
    [self.recorder prepareToRecord];
}

- (void) startRecording {
	AVAudioSession *session = [AVAudioSession sharedInstance];
	NSError *error = nil;
	[session setActive:YES error:&error];

	[self.recorder record];
	
	self.startRecordDate = [NSDate date];
	self.stopRecordDate = nil;
	
	[self showRecording];
}

- (void) pauseRecording {
	[self.recorder pause];
	self.stopRecordDate = [NSDate date];
}

- (void) stopRecording {
	AVAudioSession *session = [AVAudioSession sharedInstance];
	
	[self.recorder stop];
	
	NSError *error = nil;
	[session setActive:NO error:&error];
	
	self.stopRecordDate = [NSDate date];
	
	[self hideRecording];
}

- (void) updatePlayState {
	if (self.player.playing) {
		[self.playButton setImage:[[BMFBase sharedInstance] imageNamed:@"stop"] forState:UIControlStateNormal];
//		[self.playButton setTitle:BMFLocalized(@"Stop", nil) forState:UIControlStateNormal];
	}
	else {
		[self.playButton setImage:[[BMFBase sharedInstance] imageNamed:@"play"] forState:UIControlStateNormal];

//		[self.playButton setTitle:BMFLocalized(@"Play", nil) forState:UIControlStateNormal];
	}
}

#pragma mark AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	[self updatePlayState];
}

@end
