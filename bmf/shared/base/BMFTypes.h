
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#endif

#define LOG_ASYNC_ENABLED YES
#define LOG_LEVEL_DEF ddLogLevel
#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#endif

#pragma mark Errors
typedef NS_ENUM(NSUInteger, BMFLogContexts) {
    BMFLogGlobalContext,
	BMFLogCoreContext,
	BMFLogParseContext,
	BMFLogSubspecContext,
    BMFLogNetworkContext,
    BMFLogBehaviorContext,
	BMFLogUIContext,
	BMFLogAppContext
};

#define BMFInvalidDouble -DBL_MAX

#define BMFLogError(frmt, ...)   LOG_MAYBE(NO,                LOG_LEVEL_DEF, DDLogFlagError,   BMFLogAppContext, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define BMFLogWarn(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, BMFLogAppContext, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define BMFLogInfo(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    BMFLogAppContext, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define BMFLogDebug(frmt, ...)   LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   BMFLogAppContext, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define BMFLogVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, BMFLogAppContext, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define BMFLogErrorC(context,frmt, ...)   LOG_MAYBE(NO,                LOG_LEVEL_DEF, DDLogFlagError,   context, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define BMFLogWarnC(context,frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, context, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define BMFLogInfoC(context,frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    context, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define BMFLogDebugC(context,frmt, ...)   LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   context, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define BMFLogVerboseC(context,frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, context, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

// #define BMFLogError(frmt, ...)     SYNC_LOG_OBJC_MAYBE(ddLogLevel, DDLogFlagError,   BMFLogAppContext, frmt, ##__VA_ARGS__)
// #define BMFLogWarn(frmt, ...)     ASYNC_LOG_OBJC_MAYBE(ddLogLevel, DDLogFlagWarning,    BMFLogAppContext, frmt, ##__VA_ARGS__)
// #define BMFLogInfo(frmt, ...)     ASYNC_LOG_OBJC_MAYBE(ddLogLevel, DDLogFlagInfo,    BMFLogAppContext, frmt, ##__VA_ARGS__)
// #define BMFLogDebug(frmt, ...)     ASYNC_LOG_OBJC_MAYBE(ddLogLevel, DDLogFlagDebug,  BMFLogAppContext, frmt, ##__VA_ARGS__)
// #define BMFLogVerbose(frmt, ...)  ASYNC_LOG_OBJC_MAYBE(ddLogLevel, DDLogFlagVerbose, BMFLogAppContext, frmt, ##__VA_ARGS__)

// #define BMFLogErrorC(context, frmt, ...)     SYNC_LOG_OBJC_MAYBE(ddLogLevel, DDLogFlagError,   context, frmt, ##__VA_ARGS__)
// #define BMFLogWarnC(context, frmt, ...)     ASYNC_LOG_OBJC_MAYBE(ddLogLevel, DDLogFlagWarning,    context, frmt, ##__VA_ARGS__)
// #define BMFLogInfoC(context, frmt, ...)     ASYNC_LOG_OBJC_MAYBE(ddLogLevel, DDLogFlagInfo,    context, frmt, ##__VA_ARGS__)
// #define BMFLogDebugC(context, frmt, ...)     ASYNC_LOG_OBJC_MAYBE(ddLogLevel, DDLogFlagDebug,  context, frmt, ##__VA_ARGS__)
// #define BMFLogVerboseC(context, frmt, ...)  ASYNC_LOG_OBJC_MAYBE(ddLogLevel, DDLogFlagVerbose, context, frmt, ##__VA_ARGS__)

#pragma mark Assertions

#define BMFAssertReturn(condition) do{ NSAssert((condition), @"Invalid condition not satisfying: %s", #condition);\
if(!(condition)) { DDLogError(@"Invalid condition not satisfying: %s", #condition); return;} } while(0)

#define BMFAssertReturnZero(condition) do{ NSAssert((condition), @"Invalid condition not satisfying: %s", #condition);\
if(!(condition)) { DDLogError(@"Invalid condition not satisfying: %s", #condition); return 0;} } while(0)

#define BMFAssertReturnSizeZero(condition) do{ NSAssert((condition), @"Invalid condition not satisfying: %s", #condition);\
if(!(condition)) { DDLogError(@"Invalid condition not satisfying: %s", #condition); return CGSizeZero;} } while(0)

#define BMFAssertReturnRectZero(condition) do{ NSAssert((condition), @"Invalid condition not satisfying: %s", #condition);\
if(!(condition)) { DDLogError(@"Invalid condition not satisfying: %s", #condition); return CGRectZero;} } while(0)

#define BMFAssertReturnNO(condition) do{ NSAssert((condition), @"Invalid condition not satisfying: %s", #condition);\
if(!(condition)) { DDLogError(@"Invalid condition not satisfying: %s", #condition); return NO;} } while(0)

#define BMFAssertReturnNil(condition) do{ NSAssert((condition), @"Invalid condition not satisfying: %s", #condition);\
if(!(condition)) { DDLogError(@"Invalid condition not satisfying: %s", #condition); return nil;} } while(0)

#define BMFThrowException(message, ...) do { [NSException raise:@"%@" #message format:@""]; DDLogError(@"" #message,## __VA_ARGS__); } while (0)

//#define BMFThrowException(message, ...) do { [NSException raise:[NSString stringWithFormat:(message), ## __VA_ARGS__] format:nil]; } while (0)

#define BMFAbstractMethod() do { [NSException raise:@"Error: subclass should implement this method. Are you using the abstract class?" format:@""]; } while (0)


#pragma mark Nullable

#if !__has_feature(nullability)
#define NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_END
#define nullable
#define nonnull
#define null_unspecified
#define null_resettable
#define __nullable
#define __nonnull
#define __null_unspecified
#endif

#pragma mark Constants

#define BMFLocalConstant(type,name,value) static type const name = value;
#define BMFDeclareGlobalConstant(type,name) extern type const name;
#define BMFDefineGlobalConstant(type,name,value) type const name = value;
#define BMFDeclareGlobalNotificationConstant(name) extern NSString *const name;
#define BMFDefineGlobalNotificationConstant(name) NSString *const name = @"" # name;

#pragma mark Math

#define BMF_RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define BMF_DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


#pragma mark Base classes cross platform defines

#if TARGET_OS_IPHONE

#define BMF_SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define BMF_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define BMF_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define BMF_SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define BMF_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define BMFIXView UIView
#define BMFIXImage UIImage
#define BMFIXColor UIColor
#define BMFIXFont UIFont
#define BMFIXPasteboard UIPasteboard
#define BMFIXControl UIControl

#define BMFApplicationWillEnterForegroundNotification UIApplicationWillEnterForegroundNotification
#define BMFApplicationDidEnterBackgroundNotification UIApplicationDidEnterBackgroundNotification
#define BMFApplicationDidChangeOrientationNotification UIApplicationDidChangeStatusBarOrientationNotification
#define BMFApplicationWillTerminateNotification UIApplicationWillTerminateNotification
#define BMFApplicationDidBecomeActiveNotification UIApplicationDidBecomeActiveNotification
#define BMFApplicationWillResignActiveNotification UIApplicationWillResignActiveNotification

#else

#define BMFIXView NSView
#define BMFIXImage NSImage
#define BMFIXColor NSColor
#define BMFIXFont NSFont
#define BMFIXPasteboard NSPasteboard
#define BMFIXControl NSControl

#define BMFApplicationWillEnterForegroundNotification NSApplicationDidBecomeActiveNotification
#define BMFApplicationDidEnterBackgroundNotification NSApplicationDidResignActiveNotification
#define BMFApplicationDidChangeOrientationNotification @"BMFApplicationDidChangeOrientationNotification"
#define BMFApplicationWillTerminateNotification NSApplicationWillTerminateNotification
#define BMFApplicationDidBecomeActiveNotification NSApplicationDidBecomeActiveNotification
#define BMFApplicationWillResignActiveNotification NSApplicationWillResignActiveNotification

#endif

#pragma mark Blocks

typedef void(^BMFBlock)();
typedef void(^BMFCompletionBlock)(id result,NSError *error);
typedef void(^BMFActionBlock)(id sender);
typedef void(^BMFObjectActionBlock)(id object);
typedef void(^BMFItemActionBlock)(id item,NSIndexPath *indexPath);
typedef void(^BMFAsyncBlock)(BMFBlock doneBlock);
typedef void(^BMFOperationBlock)(id sender,BMFCompletionBlock completionBlock);
typedef NSComparisonResult(^BMFComparisonBlock)(id obj1,id obj2);

typedef void(^BMFItemBlock)(id item);
typedef id(^BMFCombineBlock)(id result,id input);
typedef id(^BMFMapBlock)(id input);
typedef BOOL(^BMFFilterBlock)(id input);
typedef BOOL(^BMFFilterIndexBlock)(id input,NSUInteger index);

#define BMFSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define BMFSupressDeprecationWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

typedef NS_ENUM(NSInteger, BMFErrorCodes) {
	BMFErrorUnknown,
	BMFErrorAssertion,
	BMFErrorFiltered,
	BMFErrorCancelled = -999,
	BMFErrorData,
	BMFErrorLoad,
	BMFErrorLacksRequiredData,
	BMFErrorInvalidType,
	BMFErrorTimeout = -1001
};

#pragma mark Enums

enum {
    BMFLayoutPriorityRequired = 1000,
    BMFLayoutPriorityDefaultHigh = 750,
    BMFLayoutPriorityDragThatCanResizeWindow = 510,
    BMFLayoutPriorityWindowSizeStayPut = 500,
    BMFLayoutPriorityDragThatCannotResizeWindow = 490,
    BMFLayoutPriorityDefaultLow = 250,
    BMFLayoutPriorityFittingSizeCompression = 50
};
typedef float BMFLayoutPriority;

typedef NS_ENUM(NSInteger, BMFDeviceFamily) {
    BMFDeviceFamilyIPad,
    BMFDeviceFamilyIPhone,
    BMFDeviceFamilyMac
};

typedef NS_ENUM(NSInteger, BMFDeviceOrientationAxis) {
	BMFDeviceOrientationAxisUnknown,
	BMFDeviceOrientationAxisPortrait,
	BMFDeviceOrientationAxisLandscape
};

typedef NS_ENUM(NSInteger, BMFContentMode) {
    BMFContentModeScaleToFill,
    BMFContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
    BMFContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
    BMFContentModeCenter,              // contents remain same size. positioned adjusted.
    BMFContentModeTop,
    BMFContentModeBottom,
    BMFContentModeLeft,
    BMFContentModeRight,
    BMFContentModeTopLeft,
    BMFContentModeTopRight,
    BMFContentModeBottomLeft,
    BMFContentModeBottomRight,
};


#if TARGET_OS_IPHONE

typedef NS_ENUM(NSUInteger, BMFTextAlignment) {
	BMFTextAlignmentLeft = NSTextAlignmentLeft,
	BMFTextAlignmentCenter = NSTextAlignmentCenter,
	BMFTextAlignmentRight = NSTextAlignmentRight,
	BMFTextAlignmentJustified = NSTextAlignmentJustified,
	BMFTextAlignmentNatural = NSTextAlignmentNatural,
};

typedef NS_ENUM(NSInteger, BMFLayoutConstraintAxis) {
	BMFLayoutConstraintAxisHorizontal = UILayoutConstraintAxisHorizontal,
    BMFLayoutConstraintAxisVertical = UILayoutConstraintAxisVertical
};

typedef NS_ENUM(NSInteger, BMFDeviceOrientation) {
	BMFDeviceOrientationUnknown = UIDeviceOrientationUnknown,
	BMFDeviceOrientationPortrait = UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
	BMFDeviceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
	BMFDeviceOrientationLandscapeLeft = UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
	BMFDeviceOrientationLandscapeRight = UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
	BMFDeviceOrientationFaceUp = UIDeviceOrientationFaceUp,              // Device oriented flat, face up
	BMFDeviceOrientationFaceDown = UIDeviceOrientationFaceDown             // Device oriented flat, face down
};


typedef NS_ENUM(NSInteger, BMFDeviceBatteryState) {
	BMFDeviceBatteryStateUnknown = UIDeviceBatteryStateUnknown,
	BMFDeviceBatteryStateUnplugged = UIDeviceBatteryStateUnplugged,   // on battery, discharging
	BMFDeviceBatteryStateCharging = UIDeviceBatteryStateCharging,    // plugged in, less than 100%
	BMFDeviceBatteryStateFull = UIDeviceBatteryStateFull,        // plugged in, at 100%
};

#define BMFViewKindSectionHeader UICollectionElementKindSectionHeader
#define BMFViewKindSectionFooter UICollectionElementKindSectionFooter

#else 

typedef NS_ENUM(NSUInteger, BMFTextAlignment) {
	BMFTextAlignmentLeft = NSLeftTextAlignment,
	BMFTextAlignmentCenter = NSCenterTextAlignment,
	BMFTextAlignmentRight = NSRightTextAlignment,
	BMFTextAlignmentJustified = NSJustifiedTextAlignment,
	BMFTextAlignmentNatural = NSNaturalTextAlignment
};

typedef NS_ENUM(NSInteger, BMFLayoutConstraintAxis) {
	BMFLayoutConstraintAxisHorizontal = 0,
    BMFLayoutConstraintAxisVertical = 1
};

typedef NS_ENUM(NSInteger, BMFDeviceOrientation) {
    BMFDeviceOrientationUnknown,
    BMFDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
    BMFDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
    BMFDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
    BMFDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
    BMFDeviceOrientationFaceUp,              // Device oriented flat, face up
    BMFDeviceOrientationFaceDown             // Device oriented flat, face down
};


typedef NS_ENUM(NSInteger, BMFDeviceBatteryState) {
	BMFDeviceBatteryStateUnknown,
	BMFDeviceBatteryStateUnplugged,   // on battery, discharging
	BMFDeviceBatteryStateCharging,    // plugged in, less than 100%
	BMFDeviceBatteryStateFull,        // plugged in, at 100%
};

#define BMFViewKindSectionHeader @"NSCollectionElementKindSectionHeader"
#define BMFViewKindSectionFooter @"NSCollectionElementKindSectionFooter"

#endif

//typedef NS_ENUM(NSUInteger, BMFViewKind) {
//	BMFViewKindSectionHeader,
//	BMFViewKindSectionFooter,
//	BMFViewKindCell
//};

//BMFDeclareGlobalConstant(NSString *,BMFViewKindSectionHeader);
//BMFDeclareGlobalConstant(NSString *,BMFViewKindSectionFooter);
//BMFDeclareGlobalConstant(NSString *,BMFViewKindCell);


typedef NSString BMFViewKind;

#define BMFViewKindCell @"Cell"

#pragma mark Notifications

BMFDeclareGlobalNotificationConstant(BMFDataWillChangeNotification);
BMFDeclareGlobalNotificationConstant(BMFDataSectionInsertedNotification);
BMFDeclareGlobalNotificationConstant(BMFDataSectionDeletedNotification);
BMFDeclareGlobalNotificationConstant(BMFDataInsertedNotification);
BMFDeclareGlobalNotificationConstant(BMFDataMovedNotification);
BMFDeclareGlobalNotificationConstant(BMFDataUpdatedNotification);
BMFDeclareGlobalNotificationConstant(BMFDataDeletedNotification);
BMFDeclareGlobalNotificationConstant(BMFDataDidChangeNotification);
BMFDeclareGlobalNotificationConstant(BMFDataBatchChangeNotification);

#pragma mark Imports

#import "NSObject+BMF.h"
#import "NSObject+BMFAspects.h"
#import "BMFConfigurationProtocol.h"
#import "NSString+BMF.h"
#import "BMFMutableWeakArray.h"
#import "NSIndexPath+BMF.h"

#import "BMFColor.h"
#import "BMFImage.h"
#import "BMFFont.h"
#import "BMFApplication.h"

#import "BMFDevice.h"


#if TARGET_OS_IPHONE
#import "UIView+BMF.h"
#import "UIViewController+BMF.h"
#import "UITableView+BMF.h"
#import "UICollectionView+BMF.h"
#endif

