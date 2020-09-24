//
//  BMFFileUpdater.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 3/10/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"
#import "BMFValidatorProtocol.h"
#import "BMFProgress.h"

/// This class copies a resource file to a local path the first time, and then keeps it updated from a remote url
@interface BMFFileUpdater : NSObject

@property (nonatomic) NSDate *lastUpdatedDate;

/// Optional, but it is recommended that you include the file also locally so the the file can be read offline
@property (nonatomic, copy) NSURL *resourceFileUrl;

/// Required. Url of a file in a remote server
@property (nonatomic, copy) NSURL *remoteUrl;

/// Required. Url where the local file will be stored. It is recommended that you choose a path inside documents and then mark the file to skip backup (BMFUtils markFileSkipBackup)
@property (nonatomic, copy) NSURL *localFileUrl;

@property (nonatomic) BMFProgress *progress;

/// Optional. You can add here a validator to check if the file data is correct. If the resource data is not correct an exception will be thrown, if the remote data is not correct it won't overwrite the local file
@property (nonatomic) id<BMFValidatorProtocol> validator;

- (instancetype) initWithLocalFileUrl:(NSURL *) localFileUrl;
- (instancetype) init __attribute__((unavailable("Use initWithLocalFileUrl: instead")));

/// Creates the local file from the resource or from the remote url (if no resource), then loads the data and returns it
- (void) load: (BMFCompletionBlock) completionBlock;

/// Updates the local file with the remote. Returns the data inside the file
- (void) update:(BMFCompletionBlock) completionBlock;

@end
