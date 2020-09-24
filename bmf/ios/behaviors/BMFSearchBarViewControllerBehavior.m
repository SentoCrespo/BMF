//
//  BMFSearchBarViewControllerBehavior.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/06/14.
//
//

#import "BMFSearchBarViewControllerBehavior.h"

#import "BMF.h"
#import "BMFFixedValue.h"

@interface BMFSearchBarViewControllerBehavior()

@property (nonatomic, strong) BMFFixedValue *textValue;

@end

@implementation BMFSearchBarViewControllerBehavior

- (instancetype) initWithSearchBar:(UISearchBar *) searchBar {
	BMFAssertReturnNil(searchBar);
	
	self = [super init];
	if (self) {
		_searchBar = searchBar;
		_searchBar.delegate = self;
		_textValue = [BMFFixedValue new];
	}
	return self;
}

- (void) setSearchBar:(UISearchBar *)searchBar {
	BMFAssertReturn(searchBar);
	_searchBar = searchBar;
}

- (void) viewWillDisappear:(BOOL)animated {
	self.searchActive = NO;
	[self.searchBar resignFirstResponder];
}

#pragma mark UISearchBarDelegate

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if (searchText.length>0) self.searchActive = YES;
	else self.searchActive = NO;
	
//	id<BMFValueChangeProtocol> value = self.textValue;
	[self.textValue setCurrentValue:searchText];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	self.searchActive = NO;
	[self.searchBar resignFirstResponder];
}


@end
