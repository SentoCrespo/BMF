//
//  BMFAFDownloadTaskLoader.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/3/15.
//
//

#import "BMFAFDownloadTaskLoader.h"

#import "BMF.h"

#import <AFNetworking/AFNetworking.h>

@interface BMFAFDownloadTaskLoader()

@property (nonatomic) NSURLSessionDownloadTask *task;

@end

@implementation BMFAFDownloadTaskLoader

- (instancetype)init
{
	self = [super init];
	if (self) {
		_progress = [BMFProgress new];
		_progress.progressMessage = BMFLocalized(@"Download File", nil);
	}
	return self;
}

- (void) cancel {
	[self.task cancel];
	[self.progress stop:nil];
}

- (void) load:(BMFCompletionBlock) completionBlock {
	BMFAssertReturn(completionBlock);
	BMFAssertReturn(self.url);
	BMFAssertReturn(self.localUrl);
	
	[_progress start:self.url.absoluteString];
	
	NSProgress *taskProgress = nil;
	NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
	self.task = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:&taskProgress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
		NSError *error = nil;
		if (![[NSFileManager defaultManager] createDirectoryAtURL:[self.localUrl URLByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&error]) {
			BMFLogErrorC(BMFLogNetworkContext,@"Error creating intermediate directories for file url: %@",self.localUrl);
		}
		
		return self.localUrl;
	} completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
		[_progress stop:error];

		if (error) {
			BMFLogErrorC(BMFLogNetworkContext,@"Request error: %@",error);
		}

		completionBlock(filePath,error);
	}];

	@weakify(self)
	[RACObserve(taskProgress, fractionCompleted) subscribeNext:^(id x) {
		@strongify(self);
		self.progress.totalUnitCount = taskProgress.totalUnitCount;
		self.progress.completedUnitCount = taskProgress.completedUnitCount;
	}];
	
	[self.task resume];
}


@end
