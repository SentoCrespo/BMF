//
//  BMFImagePickerActivity.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 06/05/14.
//
//

#import "BMFActivity.h"

@interface BMFImagePickerActivity : BMFActivity

/// No by default
@property (nonatomic, assign) BOOL allowsEditing;

/// UIImagePickerControllerSourceTypeCamera by default if the camera is supported, UIImagePickerControllerSourceTypePhotoLibrary otherwise
@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;

/// UIImagePickerControllerQualityTypeHigh by default
@property (nonatomic, assign) UIImagePickerControllerQualityType qualityType;

/// UIModalPresentationCurrentContext by default
@property (nonatomic, assign) UIModalPresentationStyle modalPresentationStyle;

/// Passes the UIImagePickerController as the sender
@property (nonatomic, copy) BMFActionBlock imagePickerPresentedBlock;

- (BOOL) isSourceTypeAvailable:(UIImagePickerControllerSourceType) sourceType;

@end
