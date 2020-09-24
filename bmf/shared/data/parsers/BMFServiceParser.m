//
//  BMFServiceParser.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/07/14.
//
//

#import "BMFServiceParser.h"

#import "BMF.h"

@implementation BMFServiceParser

- (instancetype)init {
    self = [super init];
    if (self) {
        _progress = [BMFProgress new];
		_progress.key = self.parserName;
    }
    return self;
}

- (void) parse:(NSDictionary *) rawObject completion:(BMFCompletionBlock) completionBlock {
	BMFAssertReturn(completionBlock);
	
	if (!rawObject) {
		completionBlock(nil,[NSError errorWithDomain:@"Parse" code:BMFErrorLacksRequiredData userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Error: no data loaded", nil) }]);
		return;
	}
	
	if (![rawObject isKindOfClass:self.rawObjectClass]) {
		completionBlock(nil,[NSError errorWithDomain:@"Parse" code:BMFErrorInvalidType userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Error: data should be a %@", nil),NSStringFromClass(self.rawObjectClass)] }]);
		return;
	}
	
	[self.progress start:@"TRNExerciseServiceParser"];
	
	NSError *error = nil;
	id result = [self performParse:rawObject error:&error];

	[self.progress stop:error];
	
	completionBlock(result,error);
}

- (NSString *) parserName {
	return NSStringFromClass([self class]);
}

- (id) performParse:(id) rawObject error:(NSError **)error {
	BMFAbstractMethod();
	return nil;
}

- (Class) rawObjectClass {
	BMFAbstractMethod();
	return nil;
}

-(void) cancel {
	NSError *error = [NSError errorWithDomain:@"Parse" code:BMFErrorCancelled userInfo:@{ NSLocalizedDescriptionKey : BMFLocalized(@"Parse Operation Cancelled",nil) }];
	[self.progress stop:error];
}

@end
