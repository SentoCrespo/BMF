//
//  WALD_UnzipOperation.m
//  wald
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/3/15.
//  Copyright (c) 2015 Treenovum. All rights reserved.
//

#import "BMFUnzipOperation.h"

#import <zipzap/zipzap.h>

@implementation BMFUnzipOperation

- (NSString *) p_taskId {
    return [@"unzip_" stringByAppendingString:self.localZipUrl.absoluteString];
}

- (void) main {
	BMFAssertReturn(self.localZipUrl);
	
    [self.progress start:[self p_taskId]];
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	ZZArchive *archive = [ZZArchive archiveWithURL:self.localZipUrl error:&error];
	if (archive) {
		
		NSURL *targetPathUrl = self.destinationUrl;
		if (!targetPathUrl) 	targetPathUrl = [self.localZipUrl URLByDeletingLastPathComponent];
		
		for (ZZArchiveEntry* entry in archive.entries) {
			NSURL *targetFilePathUrl = [targetPathUrl URLByAppendingPathComponent:entry.fileName];
			if (entry.fileMode & S_IFDIR) {
				if (![fileManager createDirectoryAtURL:targetFilePathUrl withIntermediateDirectories:YES	 attributes:nil error:&error]) {
					DDLogError(@"Error creating directory: %@",error);
				}
			}
			else {
				if (![fileManager createDirectoryAtURL:[targetFilePathUrl URLByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&error]) {
					DDLogError(@"Error creating directory: %@",error);
				}
				
				NSError *fileError = nil;
				NSInputStream *inputStream = [entry newStreamWithError:&fileError];
				if (!inputStream) {
					BMFLogDebugC(BMFLogSubspecContext, @"Error reading input stream for entry: %@",fileError);
                    error = fileError;
					goto error;
				}
				
				if (![[NSFileManager defaultManager] createFileAtPath:targetFilePathUrl.path contents:nil attributes:nil]) {
					BMFLogDebugC(BMFLogSubspecContext, @"Error creating file at path: %@",targetFilePathUrl);
					goto error;
				}
				
				NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingToURL:targetFilePathUrl error:&fileError];
				if (!fileHandle) {
					BMFLogDebugC(BMFLogSubspecContext, @"Error getting file handle: %@",fileError);
                    error = fileError;
					goto error;
				}
				
				NSInteger bytesRead;
				NSUInteger chunkSize = (entry.uncompressedSize < 512) ? entry.uncompressedSize : 512;
				NSMutableData *streamData = [NSMutableData data];
				[inputStream open];
				
				do {
					streamData.length = chunkSize;
					bytesRead = [inputStream read:(uint8_t *)streamData.mutableBytes maxLength:chunkSize];
					bytesRead = (bytesRead < 0) ? 0 : bytesRead;
					if (bytesRead != 0) {
						streamData.length = bytesRead;
						[fileHandle writeData:streamData];
					}
				} while (bytesRead);
				
				[inputStream close];
			}
		}
		
		self.output = targetPathUrl;
	}
	
    [self.progress stop:nil];
    return;
	
	error:
		self.output = nil;
        [self.progress stop:error];
}

@end
