//
//  TRNColumnsLayoutDelegate.m
//  Bonacasa
//
//  Created by Jose Manuel Sánchez Peñarroja on 13/03/14.
//  Copyright (c) 2014 treenovum. All rights reserved.
//

#import "BMFMatrixFlowLayoutDelegate.h"

@implementation BMFMatrixFlowLayoutDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
		self.numColumns = [[BMFDeviceValue alloc] initWithDefaultValue:@2];
		
		self.outerMargin = 10;
		self.innerMargin = 10;
		self.itemAspectRatio = 1;
		
		self.verticalMode = BMFMatrixFlowLayoutDelegateVerticalModeRows;
		
		self.numRows = [[BMFDeviceValue alloc] initWithDefaultValue:@4];

		self.itemHeight = [[BMFDeviceValue alloc] initWithDefaultValue:@120];
		
		self.itemAspectRatio = 1;
    }
    return self;
}

- (void) setDefaultNumColumns:(NSUInteger)defaultNumColumns {
	self.numColumns.defaultValue = @(defaultNumColumns);
}

- (NSUInteger) defaultNumColumns {
	return [self.numColumns.defaultValue unsignedIntegerValue];
}

- (void) setDefaultNumRows:(NSUInteger)defaultNumRows {
	self.numRows.defaultValue = @(defaultNumRows);
}

- (NSUInteger) defaultNumRows {
	return [self.numRows.defaultValue unsignedIntegerValue];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	CGFloat itemWidth = [self itemWidth:collectionView.bounds.size.width];
		
	CGFloat itemHeight = [self itemHeight:itemWidth totalHeight:collectionView.bounds.size.height];
	
	return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat) itemWidth:(CGFloat) totalWidth {
	NSUInteger finalNumColumns = [[self.numColumns currentValue] integerValue];
	
	NSUInteger numOuterMargins = 2;
	NSUInteger numInnerMargins = finalNumColumns-1;
	
	return (totalWidth-(numOuterMargins*self.outerMargin+numInnerMargins*self.innerMargin))/finalNumColumns;
}

- (CGFloat) itemHeight:(CGFloat) itemWidth totalHeight:(CGFloat) totalHeight {
	if (self.verticalMode==BMFMatrixFlowLayoutDelegateVerticalModeFixed) {
		return [[self.itemHeight currentValue] floatValue];
	}
	else if (self.verticalMode==BMFMatrixFlowLayoutDelegateVerticalModeAspectRatio) {
		CGFloat aspectRatio = self.itemAspectRatio;
		if (aspectRatio==0) aspectRatio = 1;
		return itemWidth/aspectRatio;
	}
	else {
		NSUInteger finalNumRows = [[self.numRows currentValue] integerValue];
		
		NSUInteger numOuterMargins = 2;
		NSUInteger numInnerMargins = finalNumRows-1;
		
		return (totalHeight-(numOuterMargins*self.outerMargin+numInnerMargins*self.innerMargin))/finalNumRows;
	}
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(self.outerMargin, self.outerMargin, self.outerMargin, self.outerMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return self.innerMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return self.innerMargin;
}

@end
