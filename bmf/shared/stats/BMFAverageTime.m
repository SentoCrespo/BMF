//
//  BMFAverageTime.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/05/14.
//
//

#import "BMFAverageTime.h"

#import "BMF.h"

#import "BMFAverageStats.h"

#define DEFAULT_PONDERATION 1.2

@interface BMFAverageTimeData : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) CGFloat effort;

@end

@implementation BMFAverageTimeData

- (instancetype)init {
    self = [super init];
    if (self) {
        self.effort = 1;
		self.date = [NSDate date];
    }
    return self;
}
@end

static BMFAverageTime *averageTime = nil;

@interface BMFAverageTime()

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSMutableDictionary *timesDic;

@property (nonatomic, strong) BMFAverageStats *stats;
@property (nonatomic, strong) BMFAverageStats *effortStats;

@end

@implementation BMFAverageTime

+ (void) initialize {
	averageTime = [BMFAverageTime new];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
		_serialQueue = dispatch_queue_create("com.bmf.AverageTime", DISPATCH_QUEUE_SERIAL);
		dispatch_sync(_serialQueue, ^{
			_timesDic = [NSMutableDictionary dictionary];
			NSURL *url = [NSURL fileURLWithPath:[[BMFUtils applicationCacheDirectory] stringByAppendingPathComponent:@"com.bmf.AverageTime"]];
			_stats = [[BMFAverageStats alloc] initWithFileUrl:url];
			NSURL *effortUrl = [NSURL fileURLWithPath:[[BMFUtils applicationCacheDirectory] stringByAppendingPathComponent:@"com.bmf.AverageTime.effort"]];
			_effortStats = [[BMFAverageStats alloc] initWithFileUrl:effortUrl];
		});
    }
    return self;
}

+ (NSString *) p_keyWithKey:(NSString *) key sender:(id) sender {
	return [NSString stringWithFormat:@"%@%lu",key,(unsigned long)[sender hash]];
}

+ (void) startTime:(NSString *) key sender:(id)sender {
	BMFAssertReturn(key.length>0);
	
	NSString *finalKey = [self p_keyWithKey:key sender:sender];
	BMFAverageTimeData *data = [BMFAverageTimeData new];
	data.key = key;
	
	dispatch_async(averageTime.serialQueue, ^{
		averageTime.timesDic[finalKey] = data;
	});
}

+ (void) startTime:(NSString *) key effort:(CGFloat) effort sender:(id)sender {
	BMFAssertReturn(key.length>0);
	BMFAssertReturn(effort>0);
	
	NSString *finalKey = [NSString stringWithFormat:@"%@%lu",key,(unsigned long)[sender hash]];
	BMFAverageTimeData *data = [BMFAverageTimeData new];
	data.key = key;
	data.effort = effort;
	
	dispatch_async(averageTime.serialQueue, ^{
		averageTime.timesDic[finalKey] = data;
	});
}

+ (void) setEffort:(CGFloat) effort forKey:(NSString *) key sender:(id)sender {
	BMFAssertReturn(key.length>0);
	BMFAssertReturn(effort>=0);
	if (effort==0) effort=1;

	NSString *finalKey = [NSString stringWithFormat:@"%@%lu",key,(unsigned long)[sender hash]];

	dispatch_async(averageTime.serialQueue, ^{
		BMFAverageTimeData *data = averageTime.timesDic[finalKey];
//		BMFAssertReturn(data);
		
		data.effort = effort;
	});
}

+ (void) stopTime:(NSString *) key sender:(id)sender {
	BMFAssertReturn(key.length>0);

	NSString *finalKey = [self p_keyWithKey:key sender:sender];

	dispatch_async(averageTime.serialQueue, ^{
		BMFAverageTimeData *data = averageTime.timesDic[finalKey];
		BMFAssertReturn(data);
		
		NSDate *startDate = data.date;
		BMFAssertReturn(startDate);
		
		NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:startDate];
//		DDLogDebug(@"Adding time: %f for key: %@",time,key);
		
		[averageTime.timesDic removeObjectForKey:finalKey];
		
		[averageTime.stats setPonderation:DEFAULT_PONDERATION forKey:key];
		
		[averageTime.stats addValue:time forKey:key];
		
		[averageTime.effortStats addValue:data.effort forKey:key];
	});
}

+ (void) cancelTime:(NSString *) key {
	BMFAssertReturn(key.length>0);
	
	dispatch_async(averageTime.serialQueue, ^{
		[averageTime.timesDic removeObjectForKey:key];
	});
}

+ (double) averageTime:(NSString *) key {
	double average = [averageTime.stats averageValueForKey:key];
//	DDLogDebug(@"Returning average time: %f for key: %@",average,key);
	return average;
}

+ (double) averageTime:(NSString *) key effort:(CGFloat)effort {
	BMFAssertReturnZero(effort>0);
	
	double average = [self averageTime:key];
	double averageEffort = [averageTime.effortStats averageValueForKey:key];
	if (averageEffort==BMFInvalidDouble || averageEffort==0) {
		return average;
	}
	
	return average*effort/averageEffort;
}

@end
