//
//  BMFIOSDefaultFactory.h
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 31/03/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "BMFDefaultFactory.h"

#import "BMFUIFactoryProtocol.h"

@interface BMFIOSDefaultFactory : BMFDefaultFactory <BMFUIFactoryProtocol>

#pragma mark Convenience methods
- (UIViewController *) tableViewControllerWithArray:(NSArray *) items cellClassOrNib:(id) classOrNib sender:(id) sender;

- (UIView<BMFLoaderViewProtocol> *) generalLoaderView:(id) sender;
- (UIView<BMFLoaderViewProtocol> *) hudLoaderView:(id) sender;
- (UIBarItem<BMFLoaderViewProtocol> *) navBarLoaderItem:(id) sender;

#pragma mark More customizable
- (id<BMFDataSourceProtocol>) tableViewDataSourceWithStore:(id<BMFDataReadProtocol>) store cellRegister:(id<BMFCellRegisterProtocol>) cellRegister animatedUpdates:(BOOL) animatedUpdates sender:(id) sender;
- (id<BMFDataSourceProtocol>) tableViewDataSourceWithStore:(id<BMFDataReadProtocol>) store cellClassOrNib:(id) classOrNib animatedUpdates:(BOOL) animatedUpdates sender:(id) sender;
- (id<BMFDataSourceProtocol>) tableViewDataSourceWithStore:(id<BMFDataReadProtocol>) store cellClassOrNib:(id) classOrNib sender:(id) sender;
- (UIViewController *) tableViewControllerWithDataStore:(id<BMFDataReadProtocol>) dataStore cellClassOrNib:(id) classOrNib sender:(id) sender;

- (void) setupTableViewController:(BMFTableViewController *)vc withDataStore:(id<BMFDataReadProtocol>) dataStore cellClassOrNib:(id) classOrNib sender:(id) sender;

#pragma mark Collection view

- (id<BMFDataSourceProtocol>) collectionViewDataSourceWithStore:(id<BMFDataReadProtocol>) store cellRegister:(id<BMFCellRegisterProtocol>)cellRegister animatedUpdates:(BOOL) animatedUpdates sender:(id) sender;

- (id<BMFDataSourceProtocol>) collectionViewDataSourceWithStore:(id<BMFDataReadProtocol>) store cellIdentifier:(NSString *)cellIdentifier sender:(id) sender;

- (id<BMFDataSourceProtocol>) collectionViewDataSourceWithStore:(id<BMFDataReadProtocol>) store cellClassOrNib:(id) classOrNib sender:(id) sender;
- (id<BMFDataSourceProtocol>) collectionViewDataSourceWithStore:(id<BMFDataReadProtocol>) store cellClassOrNib:(id) classOrNib animatedUpdates:(BOOL) animatedUpdates sender:(id) sender;
- (id<BMFDataSourceProtocol>) collectionViewDataSourceWithStore:(id<BMFDataReadProtocol>) store cellRegisterBlock:(BMFCellRegisterCellsBlock) registerBlock cellIdBlock:(BMFCellIdBlock)cellIdBlock sender:(id) sender;


#pragma mark Cell Register
- (id<BMFCellRegisterProtocol>) blockCellRegister:(BMFCellRegisterCellsBlock)registerBlock cellIdBlock:(BMFCellIdBlock) cellIdBlock sender:(id)sender;


#pragma mark Map view

- (id<BMFDataSourceProtocol>) mapViewDataSourceWithStore:(id<BMFDataReadProtocol>) store sender:(id) sender;
- (UIViewController *) mapViewControllerWithStore:(id) store sender:(id) sender;

@end
