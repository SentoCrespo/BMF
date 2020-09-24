//
//  BMFAppDelegate.m
//  BMFMac
//
//  Created by Jose Manuel Sánchez Peñarroja on 21/03/14.
//  Copyright (c) 2014 josé manuel sánchez. All rights reserved.
//

#import "BMFAppDelegate.h"

#import "BMFBase.h"

#import "BMFImage.h"
#import "BMFAutoLayoutUtils.h"

@implementation BMFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	
	/*CGFloat imageSize = 120;
	
	BMFIXImage *image = [BMFImage imageByDrawing:^{
//		[@"Hello, World! this is a very simple test, ok?" drawInRect:CGRectMake(0, 0, imageSize, imageSize) withAttributes:@{ NSFontAttributeName : [BMFIXFont fontWithName:@"Helvetica" size:20] }];
		
		NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
		paragraphStyle.alignment = BMFTextAlignmentCenter;
		
		[@"Hello, World! this is a very simple test, ok?" drawInRect:CGRectMake(0, 0, imageSize, imageSize) withAttributes:@{
																															 NSFontAttributeName : [BMFIXFont fontWithName:@"Helvetica" size:20],
																															 NSParagraphStyleAttributeName : paragraphStyle
																															 }];
		
//		[@"Hello" drawInRect:CGRectMake(6.0, 13.0, 28, 19) withFont:[BMFIXFont fontWithName:@"Helvetica" size:18] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];

//		[@"Hello, World! this is a very simple test, ok?" drawInRect:NSMakeRect(0, 0, imageSize, imageSize) withAttributes:@{ NSFontAttributeName : [BMFIXFont fontWithName:@"Helvetica" size:20] }];
	} size:CGSizeMake(imageSize, imageSize)];
	
	NSImageView *imageView = [NSImageView new];
	[self.window.contentView addSubview:imageView];
	[BMFAutoLayoutUtils fill:imageView parent:self.window.contentView margin:0];
	
	imageView.image = image;*/
	
	
	id<BMFDataReadProtocol> dataStore = [[BMFBase sharedInstance].factory dataStoreWithParameter:@[ @1,@2,@3 ] sender:self];
	
	BMFAssertReturn(dataStore);
	BMFAssertReturn([dataStore allItems].count==3);
	
	NSLog(@"All is good");
}

@end
