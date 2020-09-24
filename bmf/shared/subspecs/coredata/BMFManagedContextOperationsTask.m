//
//  BMFManagedContextOperationsTask.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 13/06/14.
//
//

#import "BMFManagedContextOperationsTask.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import <CoreData/CoreData.h>

@interface BMFManagedContextOperationsTask()

@property (nonatomic, assign) NSUInteger batchIndex;

@end

@implementation BMFManagedContextOperationsTask

- (instancetype) initWithOperations:(NSArray *) operations inContext:(NSManagedObjectContext *) context {
	self = [super initWithOperations:operations];
    if (self) {
		self.context = context;
		_batchIndex = 0;
    }
    return self;
}

- (void) prepareForStart {
	[super prepareForStart];
	
	@weakify(self);
	[[self.operations rac_sequence] scanWithStart:nil reduce:^id(id previous, NSOperation *current) {
		@strongify(self);
		current.completionBlock = ^() {
			[self operationCompleted];
		};
		return current;
	}];
}

- (void) prepareForFinish {
	[super prepareForFinish];
	
	self.batchIndex = self.batchCount;
	
	[self saveContext];
}

- (void) operationCompleted {
	self.batchIndex++;
	if (self.batchIndex==self.batchCount) {
		[self saveContext];
		self.batchIndex = 0;
	}
}

- (void) saveContext {
	[self.context performBlock:^{
		if (!self.context.hasChanges) return;
		
		NSError *error = nil;
		if (![self.context save:&error]) {
			DDLogError(@"Error saving BMFManagedContextOperationsTask context: %@",error);
		}
	}];
}

@end
