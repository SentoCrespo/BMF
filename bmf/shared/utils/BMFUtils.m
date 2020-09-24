//
//  BMFUtils.m
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/01/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import "BMFUtils.h"

#import "BMF.h"
#import "BMFDataReadProtocol.h"

#import <QuartzCore/QuartzCore.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#if !TARGET_OS_IPHONE
#import <WebKit/WebKit.h>
#endif

#import <CommonCrypto/CommonDigest.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <Base32/MF_Base32Additions.h>

#if TARGET_OS_IPHONE
@import MobileCoreServices;
#endif

static NSString *webUserAgent = nil;

@implementation BMFUtils

#pragma mark Shared methods

+ (NSString *) currentLangCode {
	return [NSLocale preferredLanguages].firstObject;
}

+ (NSString *) currentUsedLangCode {
	return [[NSBundle mainBundle] preferredLocalizations].firstObject;
}

+ (NSString *) osVersion {
#if TARGET_OS_IPHONE
	return [UIDevice currentDevice].systemVersion;
#else
	NSOperatingSystemVersion version = [[NSProcessInfo processInfo] operatingSystemVersion];
	return [NSString stringWithFormat:@"%ld.%ld.%ld",version.majorVersion,version.minorVersion,version.patchVersion];
#endif
}

+ (NSString *) appVersion {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *) appBuild {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
}

+ (NSString *) deviceOrientation {
	BMFDeviceOrientation orientation = [BMFDevice currentDeviceOrientation];
	
	if (orientation==BMFDeviceOrientationPortrait) return BMFLocalized(@"Portrait", nil);
	else if (orientation==BMFDeviceOrientationPortraitUpsideDown) return BMFLocalized(@"PortraitUpsideDown", nil);
	else if (orientation==BMFDeviceOrientationLandscapeLeft) return BMFLocalized(@"LandscapeLeft", nil);
	else if (orientation==BMFDeviceOrientationLandscapeRight) return BMFLocalized(@"LandscapeRight", nil);
	else if (orientation==BMFDeviceOrientationFaceUp) return BMFLocalized(@"FaceUp", nil);
	else if (orientation==BMFDeviceOrientationFaceDown) return BMFLocalized(@"FaceDown", nil);

	return BMFLocalized(@"Unknown", nil);
}

+ (NSData *) makePDFFrom:(BMFIXView *) view {
	
    NSData *pdfData = nil;
	
#if TARGET_OS_IPHONE
	
	NSMutableData *data = [NSMutableData data];
	
    UIGraphicsBeginPDFContextToData(data, view.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:pdfContext];
    UIGraphicsEndPDFContext();
	
	pdfData = data;
	
#else
	pdfData = [view dataWithPDFInsideRect:[view frame]];
	
#endif
	
    return pdfData;
}

+ (NSURL *)applicationSandboxStoresDirectory {
    NSURL *storesDirectory = [NSURL fileURLWithPath:[self applicationDocumentsDirectory]];
    storesDirectory = [storesDirectory URLByAppendingPathComponent:@"SharedCoreDataStores"];
    
    NSFileManager *fm = [[NSFileManager alloc] init];
    if (NO == [fm fileExistsAtPath:[storesDirectory path]]) {
        //create it
        NSError *error = nil;
        BOOL createSuccess = [fm createDirectoryAtURL:storesDirectory
                          withIntermediateDirectories:YES
                                           attributes:nil
                                                error:&error];
        if (createSuccess == NO) {
            NSLog(@"Unable to create application sandbox stores directory: %@\n\tError: %@", storesDirectory, error);
        }
    }
    return storesDirectory;
}


+ (NSString *)applicationDocumentsDirectory {
	NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	return [url path];
}

+ (NSString *)applicationCacheDirectory {
	NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
	return [url path];
}

+ (BOOL) isRetinaDisplay {
#if TARGET_OS_IPHONE
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
		return YES;
	}
	
#else
	if ([[NSScreen mainScreen] backingScaleFactor] == 2.0f) return YES;
#endif
	
	return NO;
}

+ (id) objectOrNull:(id) object {
	if (object) return object;
	return [NSNull null];
}

+ (id) objectOrNil:(id) object {
	if ([object isKindOfClass:[NSNull class]]) return nil;
	return object;
}

+ (NSString *) escapeURLString: (NSString *)url {
	
	id charSetClass = [NSCharacterSet class];
	if ([charSetClass respondsToSelector:@selector(URLQueryAllowedCharacterSet)]) {
		return [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	}
	
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
																							 (CFStringRef)url,
																							 NULL,
																							 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																							 kCFStringEncodingUTF8 ));
	
	return result;
}

+ (NSString *) unescapeURLString: (NSString *)url {
	id charSetClass = [NSCharacterSet class];
	if ([charSetClass respondsToSelector:@selector(URLQueryAllowedCharacterSet)]) {
		return [url stringByRemovingPercentEncoding];
	}
	
	return [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *) escapePathString: (NSString *)url {
	return [url base32String];
}

+ (NSString *) unescapePathString: (NSString *)url {
	return [NSString stringFromBase32String:url];
}

+ (NSString *) htmlWithDefaultStyle:(NSString *) htmlString {
	return [self htmlWithDefaultStyle:htmlString fontSize:-1];
}

+ (NSString *) htmlWithDefaultStyle:(NSString *) htmlString transparentBackground:(BOOL)transparent {
	return [self htmlWithDefaultStyle:htmlString fontSize:-1 removeMargins:NO transparentBackground:transparent];
}

+ (NSString *) htmlWithDefaultStyle:(NSString *) htmlString fontSize:(NSInteger) fontSize {
	return [self htmlWithDefaultStyle:htmlString fontSize:fontSize removeMargins:NO transparentBackground:NO];
}

+ (NSString *) htmlWithDefaultStyle:(NSString *) htmlString fontSize:(NSInteger) fontSize removeMargins:(BOOL)removeMargins transparentBackground:(BOOL)transparent {
	return [self htmlWithDefaultStyle:htmlString fontSize:fontSize textColor:nil removeMargins:removeMargins transparentBackground:transparent];
}

+ (NSString *) htmlWithDefaultStyle:(NSString *) htmlString fontSize:(NSInteger) fontSize textColor:(UIColor *)textColor removeMargins:(BOOL)removeMargins transparentBackground:(BOOL)transparent {
	if ([htmlString rangeOfString:@"/body"].location==NSNotFound) {
		NSMutableString *result = [NSMutableString string];
		[result appendString:@"<html><head><style>body { font-family: helvetica;"];
		
        if (removeMargins) {
            [result appendString:@"margin:0; padding: 0;"];
        }
		
		if (textColor) {
			CGFloat red, green, blue, alpha;
			[textColor getRed:&red green:&green blue:&blue alpha:&alpha];
			
			[result appendFormat:@"color: rgba(%d,%d,%d,%d);",(int)red*255,(int)green*255,(int)blue*255,(int)alpha*255];
		}
        
		if (fontSize>0) {
			[result appendFormat:@"font-size: %ld pt;",(long)fontSize];
		}
		
		if (transparent) {
			[result appendString:@"background-color: transparent;"];
		}
		
		[result appendString:@" }</style></head><body>"];
		[result appendString:htmlString];
		[result appendString:@"</body></html>"];
		
		return result;
	}
	
	return htmlString;
}

+ (NSURL *) tmpFileUrl {
	NSString *cachesPath = [self applicationCacheDirectory];
	NSUUID *uuid = [NSUUID UUID];
	return [NSURL fileURLWithPathComponents:@[ cachesPath, uuid.UUIDString ] ];
}

+ (NSArray *) integersRange:(NSInteger) minIndex max:(NSInteger) maxIndex {
	BMFAssertReturnNil(minIndex<=maxIndex);

	NSMutableArray *result = [NSMutableArray array];
	for (NSInteger i=minIndex;i<=maxIndex;i++) {
		[result addObject:@(i)];
	}
	return result;
}

+ (NSInteger) randomInteger:(NSInteger) minIndex max:(NSInteger) maxIndex {
	BMFAssertReturnZero(minIndex<maxIndex);
	
	uint32_t random = (uint32_t)arc4random_uniform((uint32_t)(maxIndex-minIndex+1));
	return random+minIndex;
}

+ (float) randomFloat:(float) minIndex max:(float) maxIndex {
	BMFAssertReturnZero(minIndex<maxIndex);
	
	float diff = maxIndex - minIndex;
	return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + minIndex;
}

+ (double) randomDouble:(double) minIndex max:(double) maxIndex {
	BMFAssertReturnZero(minIndex<maxIndex);
	
	double diff = maxIndex - minIndex;
	return (((double) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + minIndex;
}

+ (NSString *) randomString:(NSInteger)length {
	static const NSString *alphabet = @"abcdefghijklmnopqrstuvwxyz";
	NSInteger alphabetLength = [alphabet length];
	
	NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
	
	for (int i=0; i<length; i++) {
		[randomString appendFormat: @"%C", [alphabet characterAtIndex: (uint32_t)arc4random_uniform((uint32_t)alphabetLength) % alphabetLength]];
	}
	
	return randomString;
}

+ (NSString *) randomAlphaNumericString:(NSInteger)length {
	static const NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	NSInteger lettersLength = [letters length];

	NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
	
	for (int i=0; i<length; i++) {
		[randomString appendFormat: @"%C", [letters characterAtIndex: (uint32_t)arc4random_uniform((uint32_t)lettersLength) % lettersLength]];
	}
	
	return randomString;
}

+ (BOOL) isEven:(NSInteger)number {
	return (number%2==0);
}

+ (BOOL) isOdd:(NSInteger)number {
	return (number%2!=0);
}

+ (RACSignal *) webViewUserAgent:(NSURL *) url {
	return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			@autoreleasepool {
				static NSString *webViewAgent = nil;
				if (!webViewAgent) {
					dispatch_sync(dispatch_get_main_queue(), ^{
						#if TARGET_OS_IPHONE
						UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
						webViewAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
						#else
						WebView *webView = [[WebView alloc] initWithFrame:CGRectZero];
						webViewAgent = [webView userAgentForURL:url];
						#endif
					});
				}
				[subscriber sendNext:webViewAgent];
				[subscriber sendCompleted];
			}
		return nil;
	}] publish] autoconnect];
}

+ (BOOL) markFileSkipBackup: (NSURL *)fileUrl {
	return [self markFileSkipBackup:fileUrl error:nil];
}

+ (BOOL) markFileSkipBackup: (NSURL *)fileUrl error:(NSError **)error {
	BMFAssertReturnNO(fileUrl);
	BMFAssertReturnNO([[NSFileManager defaultManager] fileExistsAtPath:[fileUrl path]]);
	
	return [fileUrl setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:error];
}

+ (NSString*) sha1:(NSString*)input {
	const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:input.length];
	
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	
	CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
	
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
		[output appendFormat:@"%02x", digest[i]];
	}
	
	return output;
}


+ (NSString *) md5:(NSString *) input {
	const char *cStr = [input UTF8String];
	unsigned char digest[16];

	CC_MD5( cStr, (CC_LONG)strlen(cStr), digest); // This is the md5 call
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[output appendFormat:@"%02x", digest[i]];
	}
	
	return  output;
}

+ (NSString *) mimeTypeForExtension:(NSString *)extension {
	NSDictionary *dic = @{
						  @"jpg" : @"image/jpeg",
						  @"png" : @"image/png",
						  @"doc" : @"application/msword",
						  @"ppt" : @"application/vnd.ms-powerpoint",
  						  @"html" : @"text/html",
						  @"pdf": @"application/pdf"
						  };
	return dic[extension];
}

+ (NSString *) mimeTypeForFileUrl:(NSURL *) fileUrl {
	CFStringRef pathExtension = (__bridge_retained CFStringRef)[[fileUrl lastPathComponent] pathExtension];
	CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
	CFRelease(pathExtension);
	
	// The UTI can be converted to a mime type:
	
	NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
	if (type != NULL)
		CFRelease(type);
	
	return mimeType;
}

+ (NSData *) archiveImage:(BMFIXImage *) image {
	if (!image) return nil;
	
	@try {
		return [NSKeyedArchiver archivedDataWithRootObject:image];
	}
	@catch (NSException *exception) {
		DDLogError(@"Exception archiving image: %@",exception);
	}
}

+ (BMFIXImage *) unarchiveImage:(NSData *) imageData {
	if (!imageData) return nil;
	
	@try {
		return [NSKeyedUnarchiver unarchiveObjectWithData:imageData];
	}
	@catch (NSException *exception) {
		DDLogError(@"Exception unarchiving image: %@",exception);
	}
}

+ (CGSize) sizeToFitSize:(CGSize) size toSize:(CGSize) containerSize {
	return [self rectToFitRect:CGRectMake(0, 0, size.width, size.height) toRect:CGRectMake(0, 0, containerSize.width, containerSize.height) mode:BMFContentModeScaleAspectFit].size;
}

+ (CGRect) rectToFitRect:(CGRect) rect toRect:(CGRect) containerRect mode:(BMFContentMode)mode {

	CGFloat x = 0;
	CGFloat y = 0;
	CGFloat width = rect.size.width;
	CGFloat height = rect.size.height;
	
	if (mode==BMFContentModeTopLeft) {
		x = 0;
		y = 0;
	}
	else if (mode==BMFContentModeTop) {
		x = (containerRect.size.width-width)/2;
		y = 0;
	}
	else if (mode==BMFContentModeTopRight) {
		x = (containerRect.size.width-width);
		y = 0;
	}
	else if (mode==BMFContentModeRight) {
		x = (containerRect.size.width-width);
	}
	else if (mode==BMFContentModeBottomRight) {
		x = (containerRect.size.width-width);
		y = (containerRect.size.height-height);
	}
	else if (mode==BMFContentModeBottom) {
		y = (containerRect.size.height-height);
	}
	else if (mode==BMFContentModeBottomLeft) {
		x = 0;
		y = (containerRect.size.height-height);
	}
	else if (mode==BMFContentModeLeft) {
		x = 0;
	}
	else if (mode==BMFContentModeCenter) {
		x = (containerRect.size.width-width)/2;
		y = (containerRect.size.height-height)/2;
	}
	else if (mode==BMFContentModeScaleAspectFill) {
		height = containerRect.size.height;
		width = rect.size.width*height/rect.size.height;
		if (width<containerRect.size.width) {
			width = containerRect.size.width;
			height = rect.size.height*width/rect.size.width;
			x = 0;
			y = (height-containerRect.size.height)/2;
		}
		else {
			y = 0;
			x = (width-containerRect.size.width)/2;
		}
	}
	else if (mode==BMFContentModeScaleAspectFit) {
		height = containerRect.size.height;
		CGFloat aspectRatio = rect.size.width/rect.size.height;
		width = height*aspectRatio;
		if (width>containerRect.size.width) {
			width = containerRect.size.width;
			height = width/aspectRatio;
			x = 0;
			y = (containerRect.size.height-height)/2;
		}
		else {
			y = 0;
			x = (containerRect.size.width-width)/2;
		}
		
	}
	else if (mode==BMFContentModeScaleToFill) {
		x = 0;
		y = 0;
		width = containerRect.size.width;
		height = containerRect.size.height;
	}
	else {
		[NSException raise:BMFLocalized(@"Unknown content mode",nil) format:@"%ld",(long)mode];
	}
	
	return CGRectMake(x, y, width, height);
}

+ (CGRect) rectFromCenter:(CGPoint) center size:(CGSize) size {
	CGFloat w2 = size.width/2;
	CGFloat h2 = size.height/2;
	return CGRectMake(center.x-w2, center.y-h2, size.width, size.height);
}

/// Calculates a rect with size size centered in containerRect
+ (CGRect) rectCenteredInRect:(CGRect)containerRect size:(CGSize) size {
	return CGRectMake(CGRectGetMidX(containerRect)-size.width, CGRectGetMidY(containerRect)-size.height, size.width,size.height);
}

+ (CGAffineTransform) transformFromRect:(CGRect)sourceRect toRect:(CGRect)finalRect {
	CGAffineTransform transform = CGAffineTransformIdentity;
	transform = CGAffineTransformTranslate(transform, -(CGRectGetMidX(sourceRect)-CGRectGetMidX(finalRect)), -(CGRectGetMidY(sourceRect)-CGRectGetMidY(finalRect)));
	transform = CGAffineTransformScale(transform, finalRect.size.width/sourceRect.size.width, finalRect.size.height/sourceRect.size.height);
	
	return transform;
}

+ (CGFloat) itemSizeForContainerSize:(CGFloat)size numItems:(NSUInteger)numItems margin:(CGFloat)margin {
	return [self itemSizeForContainerSize:size numItems:numItems externalMargin:margin internalMargin:margin];
}

+ (CGFloat) itemSizeForContainerSize:(CGFloat)size numItems:(NSUInteger)numItems externalMargin:(CGFloat)externalMargin internalMargin:(CGFloat)internalMargin {
	BMFAssertReturnZero(numItems>0);
	return (size-externalMargin*2-(numItems-1)*internalMargin)/numItems;
}

+ (NSString *) escapePhoneString:(NSString *) phoneString {
	NSString *phone = phoneString;
	if (!phone) phone = @"";
	
	phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
	phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
	phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
	
	return [BMFUtils escapeURLString:phone];
}

+ (BOOL) copyFileAtURL:(NSURL *) originUrl toUrl:(NSURL *) destinationUrl {
	return [self copyFileAtURL:originUrl toUrl:destinationUrl overwrite:YES createIntermediatePaths:YES];
}

+ (BOOL) copyFileAtURL:(NSURL *) originUrl toUrl:(NSURL *) destinationUrl overwrite:(BOOL) overwrite createIntermediatePaths:(BOOL) createIntermediates {
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSError *error = nil;
	
	NSArray *components = [destinationUrl pathComponents];
	if (components.count>1) {
		NSArray *subcomponents = [components subarrayWithRange:(NSRange){0, components.count-1 }];
		NSString *path = [NSString pathWithComponents:subcomponents];
		
		if (![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
			BMFLogError(@"Error creating directory: %@",error);
			return NO;
		}
	}

	if ([fileManager fileExistsAtPath:destinationUrl.path]) {
		if (![fileManager removeItemAtURL:destinationUrl error:&error]) {
			DDLogError(@"Error removing existing item: %@",error);
			return NO;
		}
	}
	
	if (![fileManager copyItemAtURL:originUrl toURL:destinationUrl error:&error]) {
		DDLogError(@"Error copying item: %@", error);
		return NO;
	}
	
	return YES;
}

+ (void) runSynchronously:(BMFAsyncBlock) block {
	[self runSynchronously:block timeout:DISPATCH_TIME_FOREVER];
}

+ (void) runSynchronously:(BMFAsyncBlock) block timeout:(UInt64) timeout {
	BMFAssertReturn(block);
	
	dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
	block(^(id result, NSError *error){
		dispatch_semaphore_signal(semaphore);
	});
	dispatch_semaphore_wait(semaphore, timeout);
}

+ (void) performOncePerLaunch:(BMFBlock) block {
	BMFAssertReturn(block);
	
	static dispatch_once_t predicate;
	dispatch_once(&predicate, block);
}

/// Calls the block once (remembering the state between launches). You can use resetTaskId to run it again
+ (void) performOnce:(BMFBlock) block taskId:(NSString *) taskId {
	BMFAssertReturn(block);
	BMFAssertReturn([taskId isKindOfClass:[NSString class]] && taskId.length>0);

	BOOL performed = [[NSUserDefaults standardUserDefaults] boolForKey:taskId];
	if (!performed) {
		block();
		[[NSUserDefaults standardUserDefaults] setValue:@YES forKey:taskId];
	}
}

+ (void) performOncePerVersion:(BMFBlock) block taskId:(NSString *) taskId {
	BMFAssertReturn(block);
	BMFAssertReturn([taskId isKindOfClass:[NSString class]] && taskId.length>0);

	NSString *version = [[NSUserDefaults standardUserDefaults] stringForKey:taskId];
	NSString *appVersion = [self appVersion];
	
	if (!version || ![version isEqualToString:appVersion]) {
		block();
		[[NSUserDefaults standardUserDefaults] setValue:appVersion forKey:taskId];
	}
}

+ (void) performOncePerBuild:(BMFBlock) block taskId:(NSString *) taskId {
	BMFAssertReturn(block);
	BMFAssertReturn([taskId isKindOfClass:[NSString class]] && taskId.length>0);
	
	NSString *build = [[NSUserDefaults standardUserDefaults] stringForKey:taskId];
	NSString *appBuild = [self appBuild];
	
	if (!build || ![build isEqualToString:appBuild]) {
		block();
		[[NSUserDefaults standardUserDefaults] setValue:appBuild forKey:taskId];
	}
}

+ (void) resetTaskId:(NSString *)taskId {
	BMFAssertReturn([taskId isKindOfClass:[NSString class]] && taskId.length>0);
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:taskId];
}

+ (NSString *) stringForHTTPMethod:(BMFHTTPMethod)method {
	if (method==BMFHTTPMethodGET) return @"GET";
	else if (method==BMFHTTPMethodPOST) return @"POST";
	else if (method==BMFHTTPMethodPUT) return @"PUT";
	else if (method==BMFHTTPMethodHEAD) return @"HEAD";
	else if (method==BMFHTTPMethodPATCH) return @"PATCH";
	else if (method==BMFHTTPMethodDELETE) return @"DELETE";
	
	return @"GET";
}

#pragma mark UIDataSource
+ (NSIndexPath *) predecessorOf:(NSIndexPath *) indexPath inDataSource:(id<BMFDataReadProtocol>)dataSource wrap:(BOOL)wrap {
	BMFAssertReturnNil([dataSource indexPathInsideBounds:indexPath]);
	
	NSInteger row = indexPath.BMF_row;
	NSInteger section = indexPath.BMF_section;
	
	row--;
	
	if (row<0) {
		section--;
		if (section<0) {
			if (!wrap) return indexPath;
		}
		section = [dataSource numberOfSections]-1;
		row = MAX([dataSource numberOfRowsInSection:section]-1,0);
	}
	
	return [NSIndexPath BMF_indexPathForRow:row inSection:section];
}

+ (NSIndexPath *) sucessorOf:(NSIndexPath *) indexPath inDataSource:(id<BMFDataReadProtocol>)dataSource wrap:(BOOL)wrap {
	BMFAssertReturnNil([dataSource indexPathInsideBounds:indexPath]);
	
	NSInteger row = indexPath.BMF_row;
	NSInteger section = indexPath.BMF_section;
	
	row++;
	if (row>=[dataSource numberOfRowsInSection:section]) {
		row = 0;
		section++;
		if (section>=[dataSource numberOfSections]) {
			if (!wrap) return indexPath;
			section = 0;
		}
	}
	
	return [NSIndexPath BMF_indexPathForRow:row inSection:section];
}

#pragma mark iPhone only methods
#if TARGET_OS_IPHONE

#pragma mark Status bar style

+ (UIStatusBarStyle) statusBarStyleFromBarStyle:(UIBarStyle)style {
	if (style==UIBarStyleDefault) return UIStatusBarStyleDefault;
	return UIStatusBarStyleLightContent;
}

+ (UIBarStyle) barStyleFromStatusBarStyle:(UIStatusBarStyle)style {
	if (style==UIStatusBarStyleDefault) return UIBarStyleDefault;
	return UIBarStyleBlack;
}

+ (void) showNavigationBarLoading: (UIViewController *)vc {
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	[activityIndicator startAnimating];
	UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	
	vc.navigationItem.rightBarButtonItem = barButton;
}

+ (void) hideNavigationBarLoading: (UIViewController *)vc {
	vc.navigationItem.rightBarButtonItem = nil;
}

+ (NSString *) uniqueDeviceIdentifier {
	NSString *uuid = nil;
	
	uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	
	return uuid;
}

+ (UIImage *) imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
	
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return img;
}

+ (UIImage *) cropImage:(UIImage *)image rect:(CGRect)rect {
    if (image.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * image.scale,
                          rect.origin.y * image.scale,
                          rect.size.width * image.scale,
                          rect.size.height * image.scale);
    }
	
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

+ (UIViewController *) extractDetailViewController:(UIViewController *) viewController {
	UINavigationController *navController = [UINavigationController BMF_cast:viewController];
	if (navController) {
		viewController = navController.viewControllers.firstObject;
	}
	
	UITabBarController *tabController = [UITabBarController BMF_cast:viewController];
	if (tabController) {
		viewController = tabController.selectedViewController;
	}
	
	return viewController;
}

+ (NSArray *) extractDetailViewControllers:(UIViewController *) viewController {
	
	NSMutableArray *results = [NSMutableArray array];
	
	UITabBarController *tabController = [UITabBarController BMF_cast:viewController];
	if (tabController) {
		for (UIViewController *vc in tabController.viewControllers) {
			[results addObject:[self extractDetailViewController:vc]];
		}
	}
	
	UINavigationController *navController = [UINavigationController BMF_cast:viewController];
	if (navController) {
		[results addObjectsFromArray:[self extractDetailViewControllers:navController.viewControllers.firstObject]];
	}
	
	if (results.count==0) [results addObject:viewController];
	
	return results;
}

#endif



@end
