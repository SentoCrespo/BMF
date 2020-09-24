//
//  BMFAverageTime.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/05/14.
//
//

#import <Foundation/Foundation.h>

@interface BMFAverageTime : NSObject

+ (void) startTime:(NSString *) key sender:(id) sender;

/// Effort is a measure of how hard it is the task. You can use the number of objects, the number of bytes, the nerwork condition, etc
+ (void) startTime:(NSString *) key effort:(CGFloat) effort sender:(id) sender;
+ (void) setEffort:(CGFloat) effort forKey:(NSString *) key sender:(id) sender;

+ (void) stopTime:(NSString *) key sender:(id)sender;

+ (double) averageTime:(NSString *) key;
+ (double) averageTime:(NSString *) key effort:(CGFloat) effort;

+ (void) cancelTime:(NSString *) key;

@end
