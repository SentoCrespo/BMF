//
//  BMFTask.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 08/01/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFOperationsTask.h"

#import "BMFBlockOperation.h"
#import "BMF.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BMFOperationsTask()

@property (nonatomic, strong) NSOperationQueue *privateQueue;

@end

@implementation BMFOperationsTask

- (instancetype) initWithOperations:(NSArray *) operations {
    self = [super init];
    if (self) {
//        self.privateQueue = [[NSOperationQueue alloc] init];
//		self.privateQueue.name = @"BMFOperationsTask operation queue";
		self.usePrivateQueue = NO;
		
		self.operations = [operations mutableCopy];
		
		self.manualDependencies = NO;
		
		self.progress = [BMFProgress new];
		for (id operation in operations) {
			BMFOperation *op = [BMFOperation BMF_cast:operation];
			[self.progress addChild:op.progress];
		}
    }
    return self;
}

- (id)init {
	DDLogError(@"An operations task needs operations, use initWithOperations instead");
    return nil;
}

- (void) setUsePrivateQueue:(BOOL)usePrivateQueue {
	if (self.progress.running) {
		DDLogError(@"Error: can't change queue mode while running");
		return;
	}
	_usePrivateQueue = usePrivateQueue;
	if (usePrivateQueue) {
		self.privateQueue = [[NSOperationQueue alloc] init];
		self.privateQueue.name = @"BMFOperationsTask operation queue";
		self.queue = self.privateQueue;
	}
	else {
		self.privateQueue = nil;
		self.queue = [BMFBase sharedInstance].backgroundQueue;
	}
}

- (void) addOperation:(BMFOperation *) operation {
	[self.operations addObject:operation];
	
	[self.progress addChild:operation.progress];
}

- (void) addOperations:(NSArray *) operations {
	for (BMFOperation *op in operations) {
		[self addOperation:op];
	}
}

- (void) prepareForStart {
	if (!self.manualDependencies) {
		[self.operations enumerateObjectsUsingBlock:^(id current, NSUInteger idx, BOOL *stop) {
			if (idx>0) {
				id previous = self.operations[idx-1];
				[current addDependency:previous];
			}
		}];
	}
}

- (void) prepareForFinish {}

- (BOOL) start: (BMFCompletionBlock) completion {
	return [self run:completion];
}

- (BOOL) run: (BMFCompletionBlock) completion {
	
	[self prepareForStart];
    
	if (self.operations.count==0) {
		DDLogError(@"Tried to run an operations task without operations");
		if (completion) completion(nil,[NSError errorWithDomain:@"com.bmf.Task" code:BMFErrorLacksRequiredData userInfo:@{ NSLocalizedDescriptionKey : BMFLocalized(@"No operations to run", nil) }]);
		return NO;
	}
	
	BMFOperation *lastOp = self.operations.lastObject;

	BMFBlockOperation *blockOp = [[BMFBlockOperation alloc] initWithBlock:^(id sender,BMFCompletionBlock completionBlock){
		BMFBlockOperation *op = sender;
		[self prepareForFinish];
		
		for (NSOperation *dep in op.dependencies) {
			if ([dep isKindOfClass:[BMFOperation class]]) {
				BMFOperation *previous = (BMFOperation *)dep;
				
				if (completion) {
					dispatch_async(dispatch_get_main_queue(), ^{
						completion(previous.output,previous.progress.failedError);
					});
				}
				
				if (completionBlock) completionBlock(previous.output,previous.progress.failedError);
			}
		}
	} taskId:@"BMFLastTaskOperation"];

	[blockOp addDependency:lastOp];

	[self.queue addOperations:self.operations waitUntilFinished:NO];
	[self.queue addOperation:blockOp];
		
	return YES;
}

- (void) cancel {
	[self.queue cancelAllOperations];
}

#pragma mark BMFActionableProtocol

- (void) action:(id)input completion:(BMFCompletionBlock)completion {
	BMFOperation *firstOp = [BMFOperation new];
	firstOp.output = input;
	
	[self.operations insertObject:firstOp atIndex:0];
	[self run:completion];
}

@end
