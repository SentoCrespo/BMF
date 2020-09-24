//
//  BMFSearchBarViewControllerBehavior.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/06/14.
//
//

#import "BMFViewControllerBehavior.h"

#import "BMFValueProtocol.h"

@interface BMFSearchBarViewControllerBehavior : BMFViewControllerBehavior <UISearchBarDelegate>

@property (nonatomic, assign) BOOL searchActive;
@property (nonatomic, readonly) id<BMFValueProtocol, BMFValueChangeProtocol,BMFValueChangeNotifyProtocol> textValue;

@property (nonatomic, strong) UISearchBar *searchBar;

- (instancetype) initWithSearchBar:(UISearchBar *) searchBar;
- (instancetype) init __attribute__((unavailable("Use initWithSearchBar: instead")));

@end
