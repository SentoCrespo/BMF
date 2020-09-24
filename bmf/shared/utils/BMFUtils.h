//
//  BMFUtils.h
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/01/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import "BMFPlatform.h"

#import "BMFTypes.h"

#import "BMFLoaderProtocol.h"

@protocol BMFDataReadProtocol;
@class RACSignal;

@interface BMFUtils : NSObject

+ (NSString *) currentLangCode;
+ (NSString *) currentUsedLangCode;
+ (NSString *) osVersion;
+ (NSString *) appVersion;
+ (NSString *) appBuild;
+ (NSString *) deviceOrientation;

+ (NSData *) makePDFFrom:(BMFIXView *) view;

+ (NSURL *)applicationSandboxStoresDirectory;
+ (NSString *)applicationDocumentsDirectory;
+ (NSString *)applicationCacheDirectory;

+ (BOOL) isRetinaDisplay;

+ (id) objectOrNull:(id) object;
+ (id) objectOrNil:(id) object;

+ (NSString *) escapeURLString: (NSString *)url;
+ (NSString *) unescapeURLString: (NSString *)url;

+ (NSString *) escapePathString: (NSString *)url;
+ (NSString *) unescapePathString: (NSString *)url;

+ (NSString *) htmlWithDefaultStyle:(NSString *) htmlString;
+ (NSString *) htmlWithDefaultStyle:(NSString *) htmlString transparentBackground:(BOOL)transparent;
+ (NSString *) htmlWithDefaultStyle:(NSString *) htmlString fontSize:(NSInteger) fontSize;
+ (NSString *) htmlWithDefaultStyle:(NSString *) htmlString fontSize:(NSInteger) fontSize removeMargins:(BOOL)removeMargins transparentBackground:(BOOL)transparent;
+ (NSString *) htmlWithDefaultStyle:(NSString *) htmlString fontSize:(NSInteger) fontSize textColor:(UIColor *)textColor removeMargins:(BOOL)removeMargins transparentBackground:(BOOL)transparent;

+ (NSURL *) tmpFileUrl;

+ (NSArray *) integersRange:(NSInteger) minIndex max:(NSInteger) maxIndex;

#pragma mark Generate Random Numbers
+ (NSInteger) randomInteger:(NSInteger) minIndex max:(NSInteger) maxIndex;
+ (float) randomFloat:(float) minIndex max:(float) maxIndex;
+ (double) randomDouble:(double) minIndex max:(double) maxIndex;
+ (NSString *) randomString:(NSInteger)length;
+ (NSString *) randomAlphaNumericString:(NSInteger)length;

#pragma mark Math

+ (BOOL) isEven:(NSInteger)number;
+ (BOOL) isOdd:(NSInteger)number;

#pragma mark Web View
+ (RACSignal *) webViewUserAgent:(NSURL *) url;

+ (NSString *) mimeTypeForExtension:(NSString *)extension;
+ (NSString *) mimeTypeForFileUrl:(NSURL *) fileUrl;

#pragma mark Image Archiving
+ (NSData *) archiveImage:(BMFIXImage *) image;
+ (BMFIXImage *) unarchiveImage:(NSData *) imageData;

/// Calculates a size to fit containerSize with BMFContentModeScaleAspectFit
+ (CGSize) sizeToFitSize:(CGSize) size toSize:(CGSize) containerSize;

/// Calculates a rect to fit containerRect with the mode specified
+ (CGRect) rectToFitRect:(CGRect) rect toRect:(CGRect) containerRect mode:(BMFContentMode)mode;

/// Creates a rect from a center point and a size
+ (CGRect) rectFromCenter:(CGPoint) center size:(CGSize) size;

/// Calculates a rect with size size centered in containerRect
+ (CGRect) rectCenteredInRect:(CGRect)containerRect size:(CGSize) size;

+ (CGAffineTransform) transformFromRect:(CGRect)sourceRect toRect:(CGRect)finalRect;

/// Utility methods for calculating column and row sizes
+ (CGFloat) itemSizeForContainerSize:(CGFloat)size numItems:(NSUInteger)numItems margin:(CGFloat)margin;
+ (CGFloat) itemSizeForContainerSize:(CGFloat)size numItems:(NSUInteger)numItems externalMargin:(CGFloat)externalMargin internalMargin:(CGFloat)internalMargin;

/// Escape phone number for calling. This removes whitespaces, parenthesis and other symbols
+ (NSString *) escapePhoneString:(NSString *) phoneString;

/// Copies a file to a destination overwriting any existing file and creating intermediate paths
+ (BOOL) copyFileAtURL:(NSURL *) originUrl toUrl:(NSURL *) destinationUrl;
+ (BOOL) copyFileAtURL:(NSURL *) originUrl toUrl:(NSURL *) destinationUrl overwrite:(BOOL) overwrite createIntermediatePaths:(BOOL) createIntermediates;

#pragma mark Perform blocks

/// Try to avoid using these methods. It is best to do things asynchronously. Using this easily produces deadlocks
+ (void) runSynchronously:(BMFAsyncBlock) block;
+ (void) runSynchronously:(BMFAsyncBlock) block timeout:(UInt64) timeout;

+ (void) performOncePerLaunch:(BMFBlock) block;

/// Calls the block once (remembering the state between launches). You can use resetTaskId to run it again
+ (void) performOnce:(BMFBlock) block taskId:(NSString *) taskId;

/// Runs this and stores the current app version. Next time it's called it will check if the app version has changed, and only if this is the case it will call the block. Can be reset by resetTaskId
+ (void) performOncePerVersion:(BMFBlock) block taskId:(NSString *) taskId;

/// Runs this and stores the current app build. Next time it's called it will check if the app version has changed, and only if this is the case it will call the block. Can be reset by resetTaskId
+ (void) performOncePerBuild:(BMFBlock) block taskId:(NSString *) taskId;

/// This resets the task id so in the next call to performOnce it will call the block again
+ (void) resetTaskId:(NSString *)taskId;

+ (NSString *) stringForHTTPMethod:(BMFHTTPMethod)method;

#pragma mark UIDataSource
+ (NSIndexPath *) predecessorOf:(NSIndexPath *) indexPath inDataSource:(id<BMFDataReadProtocol>)dataSource wrap:(BOOL)wrap;
+ (NSIndexPath *) sucessorOf:(NSIndexPath *) indexPath inDataSource:(id<BMFDataReadProtocol>)dataSource wrap:(BOOL)wrap;

#if TARGET_OS_IPHONE

#pragma mark Status bar style

+ (UIStatusBarStyle) statusBarStyleFromBarStyle:(UIBarStyle)style;
+ (UIBarStyle) barStyleFromStatusBarStyle:(UIStatusBarStyle)style;

+ (void) showNavigationBarLoading: (UIViewController *)vc;
+ (void) hideNavigationBarLoading: (UIViewController *)vc;

+ (NSString *) uniqueDeviceIdentifier;

+ (BOOL) markFileSkipBackup: (NSURL *)url;
+ (BOOL) markFileSkipBackup: (NSURL *)url error:(NSError **)error;

+ (NSString*) sha1:(NSString*)input;
+ (NSString *) md5:(NSString *) input;

+ (UIImage *) imageWithView:(UIView *)view;
+ (UIImage *) cropImage:(UIImage *)image rect:(CGRect)rect;

/// Extracts the detail view controller from a vc that can be a container. For example, if the view controller is a navigation controller you will get the rootviewcontroller
+ (UIViewController *) extractDetailViewController:(UIViewController *) viewController;

+ (NSArray *) extractDetailViewControllers:(UIViewController *) viewController;

#endif

@end
