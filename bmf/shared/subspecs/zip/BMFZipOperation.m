//
//  WALD_ZipOperation.m
//  wald
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/3/15.
//  Copyright (c) 2015 Treenovum. All rights reserved.
//

#import "BMFZipOperation.h"

#import "BMF.h"

#import <zipzap/zipzap.h>

@implementation BMFZipOperation

- (NSString *) p_taskId {
    return [@"zip_" stringByAppendingString:[self.localUrls componentsJoinedByString:@","]];
}

- (void) main {
	BMFAssertReturn(self.localUrls.count>0);
	
    [self.progress start:[self p_taskId]];
	
	if (!self.destinationZipUrl) {
		self.destinationZipUrl = [self.localUrls.firstObject URLByAppendingPathExtension:@"zip"];
	}
	
	NSError *error = nil;
	ZZArchive *archive = [[ZZArchive alloc] initWithURL:self.destinationZipUrl options:@{ZZOpenOptionsCreateIfMissingKey : @YES} error:&error];
	[archive updateEntries:[[self.localUrls BMF_map:^id(NSURL *localUrl) {
		return [self bmf_archiveEntriesForFileUrl:localUrl];
	}] BMF_flatten] error:&error];
	
	self.output = self.destinationZipUrl;
	
    [self.progress stop:error];
}

- (NSArray *) bmf_archiveEntriesForFileUrl:(NSURL *) fileUrl {
	NSMutableArray *entries = [NSMutableArray array];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDirectory;
	if (![fileManager fileExistsAtPath:fileUrl.path isDirectory:&isDirectory]) {
		return nil;
	}
	
	if (!isDirectory) {
		return @[ [self p_entryWithFileUrl:fileUrl relativePath:fileUrl.lastPathComponent] ];
	}
	else {
		NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:fileUrl includingPropertiesForKeys:@[NSURLNameKey,NSURLIsDirectoryKey,NSURLIsRegularFileKey] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:^BOOL(NSURL *url, NSError *error) {
			BMFLogErrorC(BMFLogSubspecContext, @"Error enumerating file url: %@",error);
			return NO;
		}];
		
		NSURL *url = nil;
		while (url = [enumerator nextObject]) {
			NSError *error;
			NSNumber *isDirectory = nil;
			if (![url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
				BMFLogErrorC(BMFLogSubspecContext, @"Error checking if file is directory: %@",error);
			}
			else if (!isDirectory.boolValue) {
				NSString *relativePath = [[url.path stringByReplacingOccurrencesOfString:[fileUrl URLByDeletingLastPathComponent].path withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
				
				[entries addObject:[self p_entryWithFileUrl:url relativePath:relativePath]];
			}
		}
	}
	
	return entries;
}

- (ZZArchiveEntry *) p_entryWithFileUrl:(NSURL *) fileUrl relativePath:(NSString *)relativePath {
	return [ZZArchiveEntry archiveEntryWithFileName:relativePath compress:YES dataBlock:^NSData *(NSError *__autoreleasing *error) {
		return [[NSData alloc] initWithContentsOfURL:fileUrl];
	}];
}

@end
