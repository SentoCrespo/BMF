//
//  BMFAFDownloadTaskLoader.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/3/15.
//
//

#import <Foundation/Foundation.h>

#import "BMFLoaderProtocol.h"

@interface BMFAFDownloadTaskLoader : NSObject <BMFLoaderProtocol>

@property (nonatomic, readonly) BMFProgress *progress;

@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSURL *localUrl;

@property (nonatomic) NSData *resumeData;

/// After finishing, the url response will be available here
@property (nonatomic,readonly) NSURLResponse *response;

/// Source can be a url, a file url, a string, etc
- (void) load:(BMFCompletionBlock) completionBlock;
- (void) cancel;

@end
