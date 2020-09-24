//
//  BMFTimePickerView.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/11/14.
//
//

#import "BMFTimePickerView.h"

BMFLocalConstant(NSInteger, BMFTimePickerMinutesComponent, 0);
BMFLocalConstant(NSInteger, BMFTimePickerSeparatorComponent, 1);
BMFLocalConstant(NSInteger, BMFTimePickerSecondsComponent, 2);

@interface BMFTimePickerView() <UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation BMFTimePickerView

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self performInit];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self performInit];
	}
	return self;
}

- (void) performInit {
	self.delegate = self;
	_minutesInterval = 1;
	_secondsInterval = 5;
}

- (void) awakeFromNib {
	[self fixValues];
}

- (void) setMinutesInterval:(NSInteger)minutesInterval {
	_minutesInterval = minutesInterval;
	[self fixValues];
	[self reloadComponent:BMFTimePickerMinutesComponent];
}

- (void) setSecondsInterval:(NSInteger)secondsInterval {
	_secondsInterval = secondsInterval;
	[self fixValues];
	[self reloadComponent:BMFTimePickerSecondsComponent];
}

- (void) fixValues {
	if (_minutesInterval<=0) _minutesInterval = 1;
	if (_secondsInterval<=0) _secondsInterval = 1;
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	[self fixValues];
	
	if (component==BMFTimePickerMinutesComponent) {
		// minutes
		return 60/_minutesInterval;
	}
	else if (component==BMFTimePickerSeparatorComponent) {
		// separator
		return 1;
	}
	else {
		// seconds
		return 60/_secondsInterval;
	}
}

- (void) setSelectedTimeInterval:(NSTimeInterval)selectedTimeInterval {
	_selectedTimeInterval = selectedTimeInterval;
	
	[self fixValues];
	
	NSInteger minutes = (int)(_selectedTimeInterval/60);
	NSInteger seconds = ((int)_selectedTimeInterval%60);
	NSInteger minutesRow = minutes/_minutesInterval;
	NSInteger secondsRow = seconds/_secondsInterval;

	[self selectRow:minutesRow inComponent:BMFTimePickerMinutesComponent animated:YES];
	[self selectRow:secondsRow inComponent:BMFTimePickerSecondsComponent animated:YES];
}

#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (component==BMFTimePickerMinutesComponent) {
		return [NSString stringWithFormat:@"%d",row*_minutesInterval];
	}
	else if (component==BMFTimePickerSeparatorComponent) {
		return @":";
	}
	else {
		return [NSString stringWithFormat:@"%d",row*_secondsInterval];
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	_selectedTimeInterval = [pickerView selectedRowInComponent:BMFTimePickerMinutesComponent]*60*_minutesInterval+[pickerView selectedRowInComponent:BMFTimePickerSecondsComponent]*_secondsInterval;
	
	if (self.didChangeSelectionBlock) self.didChangeSelectionBlock(self);
}


@end
