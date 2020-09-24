//
//  AppDelegate.m
//  BMF
//
//  Created by Jose Manuel Sánchez Peñarroja on 24/12/13.
//  Copyright (c) 2013 José Manuel Sánchez. All rights reserved.
//

#import "AppDelegate.h"

#import "BMFBase.h"

#import "BMFDataLoadFactory.h"
#import "BMFDefaultConfiguration.h"
#import "BMF.h"
#import "BMFDefaultFactory.h"

#import "BMFBlockOperation.h"
#import "BMFOperationsTask.h"
#import "BMFViewController.h"
#import "BMFLoaderViewProtocol.h"

#import <MagicalRecord/MagicalRecord.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
	
	BMFDefaultConfiguration *config = [BMFDefaultConfiguration new];	
	[[BMFBase sharedInstance] loadConfig:config];
	
	
//	NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:@"Blah"];
//	fr.resultType = NSDictionaryResultType;
//	fr.propertiesToFetch = @[ @"id", @"blah" ];
//	fr.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES] ];
//	NSError *error = nil;
//	NSArray *allIds = [[NSManagedObjectContext MR_defaultContext] executeFetchRequest:fr error:&error];
//	
//
//	[NSManagedObject MR_findByAttribute:<#(NSString *)#> withValue:<#(id)#> andOrderBy:<#(NSString *)#> ascending:<#(BOOL)#>]
	
	/*NSDate *date = [NSDate date];
	NSString *string = nil;
	
	int iterations = 200000;
	for (int i=0;i<iterations;i++) {
		string = [NSString stringWithFormat:@"%d",i];
	}
	
	NSLog(@"final value: %@",string);
	NSLog(@"stringWithFormat: %f",-[date timeIntervalSinceNow]);
	
	date = [NSDate date];
	
	for (int i=0;i<iterations;i++) {
		string = [NSString BMF_stringWithInteger:i];
	}

	NSLog(@"final value: %@",string);
	NSLog(@"BMF_stringWithInteger: %f",-[date timeIntervalSinceNow]);
	
	CGFloat imageSize = 120;
	
	BMFIXImage *image = [BMFImage imageByDrawing:^{
		
		[@"Hello, World! this is a very simple test, ok?" drawInRect:CGRectMake(0, 0, imageSize, imageSize) withAttributes:@{ NSFontAttributeName : [BMFIXFont fontWithName:@"Helvetica" size:20] }];
		
//		[@"Hello, World! this is a very simple test, ok?" drawInRect:NSMakeRect(0, 0, imageSize, imageSize) withAttributes:@{ NSFontAttributeName : [BMFIXFont fontWithName:@"Helvetica" size:20] }];
	} size:CGSizeMake(imageSize, imageSize)];
	
	UIImageView *imageView = [UIImageView new];
	
	[self.window.rootViewController.view addSubview:imageView];
	[BMFAutoLayoutUtils fill:imageView parent:self.window.rootViewController.view margin:0];
	
	imageView.image = image;*/
	
	

	
	/*BMFDefaultConfiguration *config = [BMFDefaultConfiguration new];
	[[BMFBase sharedInstance] loadConfig:config];*/
	
	/*BMFDataLoadFactory *factory = [BMFDataLoadFactory new];
	id<BMFTaskProtocol> task = [factory dataLoadTask];
	[task start:^(id result, NSError *error) {
		DDLogInfo(@"done");
	}];*/
	
	/*BMFViewController *vc = self.window.rootViewController;
	BMFDefaultFactory *factory = [BMFBase sharedInstance].factory;
	vc.loaderView = [factory hudLoaderView];
	
	BMFProgress *progress1 = [BMFProgress new];
	BMFProgress *progress2 = [BMFProgress new];
	BMFProgress *progress3 = [BMFProgress new];
	
	[vc.loaderView.progress addChild:progress1];
	[vc.loaderView.progress addChild:progress2];
	[vc.loaderView.progress addChild:progress3];
	
	DDLogInfo(@"main running %d",vc.loaderView.progress.running);
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[progress1 clear];
		progress1.running = YES;
		DDLogInfo(@"main running %d",vc.loaderView.progress.running);
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
			progress1.running = NO;
			
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				DDLogInfo(@"main running %d",vc.loaderView.progress.running);
				
				progress2.running = YES;
				
				DDLogInfo(@"main running %d",vc.loaderView.progress.running);

			});
		});
	});*/

	
	/*BMFBlockOperation *op1 = [[BMFBlockOperation alloc] initWithBlock:^(id sender, BMFCompletionBlock completionBlock) {
		BMFBlockOperation *op = sender;
		op.progress.progressMessage = @"Performing op 1";
		DDLogInfo(@"main running %d",vc.loaderView.progress.running);
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			DDLogInfo(@"op 1 done");
			completionBlock(nil,nil);
		});
	}];
	

	BMFBlockOperation *op2 = [[BMFBlockOperation alloc] initWithBlock:^(id sender, BMFCompletionBlock completionBlock) {
		BMFBlockOperation *op = sender;
		op.progress.progressMessage = @"Performing op 2";

		DDLogInfo(@"main running %d",vc.loaderView.progress.running);
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			DDLogInfo(@"op 2 done");
			completionBlock(nil,nil);
		});
	}];
	
	BMFBlockOperation *op3 = [[BMFBlockOperation alloc] initWithBlock:^(id sender, BMFCompletionBlock completionBlock) {
		BMFBlockOperation *op = sender;
		op.progress.progressMessage = @"Performing op 3";

		DDLogInfo(@"main running %d",vc.loaderView.progress.running);
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			DDLogInfo(@"op 3 done");
			completionBlock(nil,nil);
		});
	}];
	
	id<BMFTaskProtocol> task = [[BMFOperationsTask alloc] initWithOperations:@[ op1, op2, op3 ]];
	[vc.loaderView.progress addChild:task.progress];

	DDLogInfo(@"main running %d",vc.loaderView.progress.running);
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		DDLogInfo(@"Task starts now");
		[task start:^(id result, NSError *error) {
			DDLogInfo(@"Task finished");
		}];
	});*/
	
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
