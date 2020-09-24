//
//  BMFAverageStats.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 29/05/14.
//
//

#import "BMFAverageStats.h"

#import "BMFAverageValue.h"

#import "BMFUtils.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACExtScope.h>

#define BMFAVERAGE_FILE @"com.bmf.stats.average.plist"

static BMFAverageStats *globalInstance = nil;

@interface BMFAverageStats()

@property (nonatomic, strong) NSMutableDictionary *valuesDic;

@property (nonatomic, strong) dispatch_queue_t serialQueue;

@property (nonatomic, strong) NSURL *fileUrl;

@end

@implementation BMFAverageStats {
	BOOL shouldSave;
}

+ (instancetype) globalStats {
	if (!globalInstance) {
		NSString *filePath = [[BMFUtils  applicationCacheDirectory] stringByAppendingPathComponent:BMFAVERAGE_FILE];
		globalInstance = [[self alloc] initWithFileUrl:[NSURL fileURLWithPath:filePath]];
	}
	
	return globalInstance;
}

- (instancetype) initWithFileUrl:(NSURL *) fileUrl {
	BMFAssertReturnNil(fileUrl);
	
	self = [super init];
	if (self) {
		_fileUrl = fileUrl;
		
		_serialQueue = dispatch_queue_create("BMFAverageStatsQueue", DISPATCH_QUEUE_SERIAL);
		
		[self load];
		
//		@weakify(self);
//		[[[self rac_signalForSelector:@selector(save)] throttle:1] subscribeNext:^(id x) {
//			@strongify(self);
//			dispatch_async(_serialQueue, ^{
//				@try {
//					NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.valuesDic];
//					if (data) [data writeToURL:self.fileUrl atomically:YES];
//				}
//				@catch (NSException *exception) {
//					DDLogError(@"Exeption writing to file url: %@ %@",self.fileUrl,exception);
//				}
//			});
//		}];
	}
	return self;
}

- (BMFAverageValue *) valueForKey: (NSString *) key {
	BMFAssertReturnNil(key.length>0);
	
	if (!self.valuesDic[key]) self.valuesDic[key] = [BMFAverageValue new];
	
	return self.valuesDic[key];
}

- (void) dealloc {
	[self performSave];
}

- (void) setPonderation:(double) ponderation forKey:(NSString *) key {
	BMFAssertReturn(ponderation>0 && ponderation<2);

	dispatch_sync(self.serialQueue, ^{
		BMFAverageValue *averageValue = [self valueForKey:key];
		averageValue.ponderation = ponderation;
		[self save];
	});
}

- (void) setDefaultValue:(double) value forKey:(NSString *) key {
	BMFAssertReturn(key.length>0);
	
	dispatch_sync(self.serialQueue, ^{
		BMFAverageValue *averageValue = [self valueForKey:key];
		averageValue.defaultValue = @(value);
		[self save];
	});
}

- (void) removeAllValuesForKey:(NSString *) key {
	BMFAssertReturn(key.length>0);
	
	dispatch_sync(self.serialQueue, ^{
		BMFAverageValue *averageValue = [self valueForKey:key];
		[averageValue clear];
		[self save];
	});
}

- (void) addValue:(double) value forKey:(NSString *) key {
	BMFAssertReturn(key.length>0);
	
	dispatch_sync(self.serialQueue, ^{
		BMFAverageValue *averageValue = [self valueForKey:key];
		[averageValue addValue:@(value)];
		[self save];
	});
}

- (double) averageValueForKey:(NSString *) key {
	BMFAssertReturnZero(key.length>0);
	
	__block double result = BMFInvalidDouble;
	
	dispatch_sync(self.serialQueue, ^{
		if (self.valuesDic[key]) {
			BMFAverageValue *averageValue = self.valuesDic[key];
			NSNumber *currentValue = [averageValue currentValue];
			if (currentValue) result = [currentValue doubleValue];
		}
	});
	
	return result;
}

- (void) removeAllValues {
	dispatch_sync(self.serialQueue, ^{
		[_valuesDic removeAllObjects];
		NSError *error = nil;
		[[NSFileManager defaultManager] removeItemAtURL:self.fileUrl error:&error];
		if (error) {
			BMFLogErrorC(BMFLogCoreContext,@"Error saving stats file: %@",error);
		}
	});
}

#pragma mark Persistence

- (void) load {
	if (shouldSave) [self performSave];
	
	dispatch_sync(self.serialQueue, ^{
		NSData *data = [NSData dataWithContentsOfURL:self.fileUrl];
		if (data) {
			@try {
				_valuesDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
			}
			@catch (NSException *exception) {
				BMFLogErrorC(BMFLogCoreContext,@"Exception reading file at url: %@ %@",self.fileUrl,exception);
				
				NSError *error = nil;
				if (![[NSFileManager defaultManager] removeItemAtURL:self.fileUrl error:&error]) {
					BMFLogErrorC(BMFLogCoreContext,@"Error removing item at url: %@",error);
				}
			}
		}

		if (!_valuesDic || ![_valuesDic isKindOfClass:[NSMutableDictionary class]]) _valuesDic = [NSMutableDictionary dictionary];
	});
}

- (void) save {
	shouldSave = YES;
}

- (void) performSave {
	if (!shouldSave) return;
	
	dispatch_sync(_serialQueue, ^{
		@try {
			NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.valuesDic];
			if (data) [data writeToURL:self.fileUrl atomically:YES];
		}
		@catch (NSException *exception) {
			BMFLogErrorC(BMFLogCoreContext,@"Exeption writing to file url: %@ %@",self.fileUrl,exception);
		}
	});
}

@end
