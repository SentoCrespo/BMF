//
//  BMFJBChartDataSource.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/08/14.
//
//

#import "BMFDataSource.h"

@class JBChartView;

@interface BMFJBChartDataSource : BMFDataSource

@property (nonatomic, weak) JBChartView *chartView;

- (instancetype) initWithDataStore:(id<BMFDataReadProtocol>)dataStore;
- (instancetype) init __attribute__((unavailable("Use initWithDataStore: instead")));

@end
