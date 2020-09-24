//
//  TRNTimePickerViewController.h
//  xinix
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/11/14.
//  Copyright (c) 2014 Treenovum. All rights reserved.
//

#import "BMFViewController.h"

#import "BMFTimePickerView.h"

@interface BMFTimePickerViewController : BMFViewController

@property (weak, nonatomic) IBOutlet BMFTimePickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
