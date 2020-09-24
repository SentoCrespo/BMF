//
//  BMFPlayMusicBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/08/14.
//
//

#import "BMFPlayMusicBehavior.h"

#import "BMF.h"

@import AVFoundation;

@interface BMFPlayMusicBehavior() <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, assign) BOOL active;

@end

@implementation BMFPlayMusicBehavior {
	id activeObserver;
	id resignActiveObserver;
}

- (instancetype) init {
//	BMFAssertReturnNil(fileUrl);
	
	self = [super init];
	if (self) {
		_repeatCount = -1;
		
		activeObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
			[self startPlaying:self];
		}];
		
		resignActiveObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
			[self stopPlaying:self];
		}];
	}
	
	return self;
}

- (void) setFileUrl:(NSURL *)fileUrl {
	BMFAssertReturn(fileUrl);
	
	_fileUrl = fileUrl;
	
	[self p_updatePlayer];
}

- (void) setRepeatCount:(NSInteger)repeatCount {
	_repeatCount = repeatCount;

	_player.numberOfLoops = repeatCount;
}

- (void) p_updatePlayer {
#if (!TARGET_IPHONE_SIMULATOR)
	if (!self.enabled) return;
	
	if (!self.fileUrl && self.resourceFileName) {
		NSString *name = [self.resourceFileName stringByDeletingPathExtension];
		NSString *extension = [self.resourceFileName pathExtension];
		
		NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:extension];
		if (url) {
			self.fileUrl = url;
		}
	}
	
	if (!self.fileUrl) return;
	
	NSError *error = nil;
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&error];
	[[AVAudioSession sharedInstance] setActive:YES error:&error];
	
	_player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.fileUrl error:&error];
	if (!_player) {
		DDLogError(@"Error initializing player: %@",error);
	}
	else {
		_player.delegate = self;
		_player.numberOfLoops = self.repeatCount;
		[_player prepareToPlay];
	}
	
#endif
}

- (IBAction) startPlaying:(id) sender {
#if (!TARGET_IPHONE_SIMULATOR)
	if (!self.enabled) return;
	
	if (!_player) [self p_updatePlayer];
	
	self.active = YES;
	[self.player play];
#endif
}

- (IBAction) stopPlaying:(id) sender {
#if (!TARGET_IPHONE_SIMULATOR)
	if (!self.enabled) return;
	
	self.active = NO;
	[self.player stop];
#endif
}

#pragma mark Events

- (void) viewDidAppear:(BOOL)animated {
	BMFAssertReturn(self.owner);
	
	[self startPlaying:self];
}

- (void) viewDidDisappear:(BOOL)animated {
	[self stopPlaying:self];
}

- (void) dealloc {
	[self stopPlaying:self];
	
	self.player = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:activeObserver], activeObserver = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:resignActiveObserver], resignActiveObserver = nil;
}

#pragma mark AVAudioPlayerDelegate

// This is done so if the user declines a call, for example the music will resume
- (void) audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
	if (self.active) [self startPlaying:self];
}

@end
