//
//  BMFAverageStats.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 29/05/14.
//
//

#import <Foundation/Foundation.h>


@interface BMFAverageStats : NSObject

+ (instancetype) globalStats;

- (instancetype) initWithFileUrl:(NSURL *) fileUrl;

- (instancetype) init __attribute__((unavailable("Use initWithFileUrl: instead")));

- (void) setPonderation:(double) ponderation forKey:(NSString *) key;
- (void) setDefaultValue:(double) value forKey:(NSString *) key;

- (void) removeAllValuesForKey:(NSString *) key;
- (void) addValue:(double) value forKey:(NSString *) key;
- (double) averageValueForKey:(NSString *) key;

- (void) removeAllValues;

@end
