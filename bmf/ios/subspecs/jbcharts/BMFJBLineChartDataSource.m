//
//  BMFJBLineChartDataSource.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/08/14.
//
//

#import "BMFJBLineChartDataSource.h"

#import <JBChartView/JBLineChartView.h>

@interface BMFJBLineChartDataSource() <JBLineChartViewDataSource, JBLineChartViewDelegate>

@property (nonatomic, strong) NSMutableArray *observationTokens;

@end

@implementation BMFJBLineChartDataSource



- (instancetype) initWithDataStore:(id<BMFDataReadProtocol>)dataStore {
    self = [super init];
    if (self) {
		_observationTokens = [NSMutableArray array];
    }
    return self;
}

- (void) observeDataChanges {
	[self stopObserving];

	[self.observationTokens addObject:[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BMFDataBatchChangeNotification object:self.dataStore] throttle:0.5] subscribeNext:^(id x) {
		[self.chartView reloadData];
	}]];
}

- (void) dealloc {
	self.dataStore = nil;
	
	[self stopObserving];
}

- (void) stopObserving {
	
	for (id token in self.observationTokens) {
		[token dispose];
	}
	
	[self.observationTokens removeAllObjects];
}

- (void) setDataStore:(id<BMFDataReadProtocol>)dataStore {
	[self stopObserving];
	
	[super setDataStore:dataStore];
	
	[self observeDataChanges];
	
	[self.chartView reloadData];
}

- (void) setChartView:(JBChartView *)chartView {
 	self.chartView = chartView;
	
	self.chartView.dataSource = self;
 		
	[self.chartView reloadData];
}

#pragma mark JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
	return [self.dataStore numberOfSections];
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
	return [self.dataStore numberOfRowsInSection:lineIndex];
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
	NSNumber *item = [self.dataStore itemAt:lineIndex row:horizontalIndex];
	if (item) return item.floatValue;
	return 0;
}

@end
