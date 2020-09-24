//
//  BMFKeyedArchiverSerializer.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 8/4/15.
//
//

#import "BMFKeyedArchiverSerializer.h"

#import "BMF.h"

@implementation BMFKeyedArchiverSerializer

- (id)init
{
	self = [super init];
	if (self) {
		_progress = [BMFProgress new];
		_progress.key = @"keyedArchiver";
		_progress.progressMessage = BMFLocalized(@"Keyed Archiver", nil);
	}
	return self;
}

- (void) cancel {
	[self.progress stop:nil];
}

- (void) parse:(NSData *)data completion:(BMFCompletionBlock)completionBlock {
	BMFAssertReturn(data);
	BMFAssertReturn(completionBlock);
	
	[self.progress start:@"com.bmf.KeyedArchiverSerializer"];
	
	@try {
		id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		[self.progress stop:nil];
		completionBlock(object,nil);
	}
	@catch (NSException *exception) {
		BMFLogError(@"Error unarchiving data: %@",exception);
		NSError *error = [NSError errorWithDomain:@"Parse" code:BMFErrorUnknown userInfo:@{ NSLocalizedDescriptionKey: [exception reason] }];
		[self.progress stop:error];
		completionBlock(nil,error);
	}
}

- (void) serialize:(id) object completion:(BMFCompletionBlock)completionBlock {
	BMFAssertReturn(object);
	BMFAssertReturn(completionBlock);

	[self.progress start:@"com.bmf.KeyedArchiverSerializer"];

	@try {
		NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
		[self.progress stop:nil];
		completionBlock(data,nil);
	}
	@catch (NSException *exception) {
		BMFLogError(@"Error archiving data: %@",exception);
		NSError *error = [NSError errorWithDomain:@"Parse" code:BMFErrorUnknown userInfo:@{ NSLocalizedDescriptionKey: [exception reason] }];
		[self.progress stop:error];
		completionBlock(nil,error);
	}
}

@end
