//
//  BMFDeleteFileOperation.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 26/3/15.
//
//

#import "BMFOperation.h"

@interface BMFDeleteFileOperation : BMFOperation

@property (nonatomic, nonnull) NSURL *fileUrl;

@end
