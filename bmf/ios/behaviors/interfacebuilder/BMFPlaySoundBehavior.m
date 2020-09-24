//
//  BMFPlaySoundBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 19/11/14.
//
//

#import "BMFPlaySoundBehavior.h"

#import "BMF.h"

@import AudioToolbox;

@interface BMFPlaySoundBehavior()

@property (nonatomic, assign) SystemSoundID soundId;

@end

@implementation BMFPlaySoundBehavior

- (void) setFileUrl:(NSURL *)fileUrl {
	BMFAssertReturn(fileUrl);
	
	_fileUrl = fileUrl;
	
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)_fileUrl, &_soundId);
}

- (void) dealloc {
	AudioServicesDisposeSystemSoundID(self.soundId);
}

- (IBAction) play:(id) sender {
	if (!self.isEnabled) return;
	
	if (!self.fileUrl && self.resourceFileName) {
		NSString *name = [self.resourceFileName stringByDeletingPathExtension];
		NSString *extension = [self.resourceFileName pathExtension];
		
		NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:extension];
		if (url) {
			self.fileUrl = url;
		}
	}
	
	if (!self.fileUrl) return;
	
	AudioServicesPlaySystemSound(self.soundId);
}

@end
